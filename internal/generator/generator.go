package generator

import (
	"fmt"
	"log/slog"

	"github.com/aburizalpurnama/gofer/internal/contract"
	"github.com/aburizalpurnama/gofer/internal/model"
)

type generator struct {
	Front   contract.FrontLayerGenerator
	Service contract.ServiceLayerGenerator
	Back    contract.BackLayerGenerator
}

func New(DBLibrary model.DBLibrary, webFramework model.WebFramerowk, logger *slog.Logger, writer contract.Writer) (*generator, error) {
	var frontGen contract.FrontLayerGenerator
	switch webFramework {
	case model.FIBER:
		frontGen = newFiberGenerator(logger, writer)
	case model.GIN:
	case model.CHI:
	default:
		return nil, fmt.Errorf("invalid Web Framework")

	}

	var backGen contract.BackLayerGenerator
	switch DBLibrary {
	case model.GORM:
		backGen = newGormGenerator(logger, writer)
	case model.SQLX:
	default:
		return nil, fmt.Errorf("invalid DBLibrary")
	}

	serviceGen := newServiceGenerator(logger, writer)

	return &generator{
		Front:   frontGen,
		Service: serviceGen,
		Back:    backGen,
	}, nil
}
