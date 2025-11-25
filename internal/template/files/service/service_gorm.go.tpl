package {{ .PackageName }}

import (
	"context"
	"errors"

	"{{ .ModulePath }}/internal/app/contract"
	"{{ .ModulePath }}/internal/app/model"
	"{{ .ModulePath }}/internal/app/payload"
	"{{ .ModulePath }}/internal/pkg/apperror"
	"{{ .ModulePath }}/internal/pkg/dberror"
	"{{ .ModulePath }}/internal/pkg/response"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/trace"
	"golang.org/x/sync/errgroup"
	"gorm.io/gorm"
)

var serviceTracer trace.Tracer = otel.Tracer("{{ .EntityVarName }}.service")

type service struct {
	uow    contract.UnitOfWork
	mapper contract.Mapper
}

// NewService initializes a new instance of {{ .EntityVarName }} service.
func NewService(uow contract.UnitOfWork, mapper contract.Mapper) contract.{{ .InterfaceName }} {
	return &service{uow: uow, mapper: mapper}
}

// Ensures implementation satisfies the contract at compile-time.
var _ contract.{{ .InterfaceName }} = (*service)(nil)

// Create{{ .EntityName }} handles the creation of a new {{ .EntityVarName }} record.
func (s *service) Create{{ .EntityName }}(ctx context.Context, req payload.{{ .EntityName }}CreateRequest) (*payload.{{ .EntityName }}BaseResponse, error) {
	ctx, span := serviceTracer.Start(ctx, "Create{{ .EntityName }}")
	defer span.End()

	var {{ .EntityVarName }} model.{{ .EntityName }}
	err := s.mapper.ToModel(req, &{{ .EntityVarName }})
	if err != nil {
		return nil, ErrMapping(err)
	}

	// TODO: Implement domain-specific business logic here.
	// Example: Validate business rules, calculate derived fields, or check external APIs.

	created, err := s.uow.{{ .EntityName }}Repository().Save(ctx, &{{ .EntityVarName }})
	if err != nil {
		// Handle database-specific errors (e.g., unique constraints)
		if pgErr := dberror.GetError(err); pgErr != nil {
			switch pgErr.Code {
			case dberror.UniqueViolation:
				msg, details := dberror.ParseUniqueConstraintError(pgErr)
				return nil, Err{{ .EntityName }}DuplicateEntry(err, details).WithMessage(msg)
			}
		}

		return nil, ErrFailedCreate{{ .EntityName }}(err)
	}

	var resp payload.{{ .EntityName }}BaseResponse
	err = s.mapper.ToResponse(created, &resp)
	if err != nil {
		return nil, ErrMapping(err)
	}

	return &resp, nil
}

// GetAll{{ .EntityNamePlural }} retrieves a list of {{ .EntityVarName }}s with support for pagination and filtering.
func (s *service) GetAll{{ .EntityNamePlural }}(ctx context.Context, req payload.{{ .EntityName }}GetAllRequest) ([]payload.{{ .EntityName }}BaseResponse, *response.Pagination, error) {
	ctx, span := serviceTracer.Start(ctx, "GetAll{{ .EntityNamePlural }}")
	defer span.End()

	var count int64
	var {{ .EntityVarName }}s []model.{{ .EntityName }}

	// Use errgroup for concurrent data fetching (count and data) to optimize performance
	group, groupCtx := errgroup.WithContext(ctx)

	group.Go(func() error {
		var err error
		count, err = s.uow.{{ .EntityName }}Repository().Count(groupCtx, req.{{ .FilterName }})
		if err != nil {
			return err
		}
		return nil
	})

	group.Go(func() error {
		var err error
		{{ .EntityVarName }}s, err = s.uow.{{ .EntityName }}Repository().FindAll(groupCtx, req.Page, req.Size, req.{{ .FilterName }})
		if err != nil {
			return err
		}
		return nil
	})

	err := group.Wait()
	if err != nil {
		return nil, nil, apperror.New(apperror.Internal, "failed to fetch {{ .EntityVarName }} data", err, nil)
	}

	var resp []payload.{{ .EntityName }}BaseResponse
	err = s.mapper.ToResponse({{ .EntityVarName }}s, &resp)
	if err != nil {
		return nil, nil, ErrMapping(err)
	}

	return resp, response.NewPagination(req.Page, req.Size, &count), nil
}

// Get{{ .EntityName }}ByID retrieves a specific {{ .EntityVarName }} by its unique identifier.
func (s *service) Get{{ .EntityName }}ByID(ctx context.Context, id {{ .PrimaryKeyType }}) (*payload.{{ .EntityName }}BaseResponse, error) {
	ctx, span := serviceTracer.Start(ctx, "Get{{ .EntityName }}ByID")
	defer span.End()

	{{ .EntityVarName }}, err := s.uow.{{ .EntityName }}Repository().FindByID(ctx, id)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, Err{{ .EntityName }}NotFound(err)
		}

		return nil, apperror.New(apperror.Internal, "failed to get {{ .EntityVarName }}", err, nil)
	}

	var resp payload.{{ .EntityName }}BaseResponse
	err = s.mapper.ToResponse({{ .EntityVarName }}, &resp)
	if err != nil {
		return nil, ErrMapping(err)
	}

	return &resp, nil
}

// Update{{ .EntityName }} modifies an existing {{ .EntityVarName }}'s information.
func (s *service) Update{{ .EntityName }}(ctx context.Context, id {{ .PrimaryKeyType }}, req payload.{{ .EntityName }}UpdateRequest) (*payload.{{ .EntityName }}BaseResponse, error) {
	ctx, span := serviceTracer.Start(ctx, "Update{{ .EntityName }}")
	defer span.End()

	{{ .EntityVarName }}, err := s.uow.{{ .EntityName }}Repository().FindByID(ctx, id)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, Err{{ .EntityName }}NotFound(err)
		}

		return nil, apperror.New(apperror.Internal, "failed to get {{ .EntityVarName }}", err, nil)
	}

	// Map request DTO to the existing model
	err = s.mapper.ToModel(req, &{{ .EntityVarName }})
	if err != nil {
		return nil, ErrMapping(err)
	}

	// TODO: Implement domain-specific update logic here.
	// Example: State transitions, validation against other entities, etc.

	updated, err := s.uow.{{ .EntityName }}Repository().Update(ctx, {{ .EntityVarName }})
	if err != nil {
		return nil, ErrFailedUpdate{{ .EntityName }}(err)
	}

	var resp payload.{{ .EntityName }}BaseResponse
	err = s.mapper.ToResponse(updated, &resp)
	if err != nil {
		return nil, ErrMapping(err)
	}

	return &resp, nil
}

// Delete{{ .EntityName }} removes a {{ .EntityVarName }} record from the database.
func (s *service) Delete{{ .EntityName }}(ctx context.Context, id {{ .PrimaryKeyType }}) error {
	ctx, span := serviceTracer.Start(ctx, "Delete{{ .EntityName }}")
	defer span.End()

	// Check existence before deletion
	_, err := s.uow.{{ .EntityName }}Repository().FindByID(ctx, id)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return Err{{ .EntityName }}NotFound(err)
		}

		return apperror.New(apperror.Internal, "failed to check {{ .EntityVarName }} existence", err, nil)
	}

	if err := s.uow.{{ .EntityName }}Repository().Delete(ctx, id); err != nil {
		return ErrFailedDelete{{ .EntityName }}(err)
	}

	return nil
}