package writer

import (
	"bytes"
	"context"
	"fmt"
	"go/format"
	"log/slog"
	"os"
	"path/filepath"
	textTemplate "text/template"

	"github.com/aburizalpurnama/gofer/internal/model"
	"github.com/aburizalpurnama/gofer/internal/template"
)

type writer struct {
	logger    *slog.Logger
	templates *textTemplate.Template
}

func New(logger *slog.Logger) (*writer, error) {
	tmpl, err := textTemplate.New("base").ParseFS(template.Content, "*.tpl", "model/*", "repository/*")
	if err != nil {
		return nil, fmt.Errorf("failed to parse template from embed.FS: %w", err)
	}

	return &writer{logger: logger, templates: tmpl}, nil
}

func (w *writer) WriteModel(ctx context.Context, targetPath string, templateName string, data model.ModelTemplateData) error {
	return w.writeGoFile(ctx, targetPath, templateName, data)
}

// func (w *writer) WriteService(ctx context.Context, targetPath string, data model.ServiceTemplateData) {
// 	return
// }

func (w *writer) writeGoFile(ctx context.Context, targetPath string, templateName string, data any) error {

	var buf bytes.Buffer
	err := w.templates.ExecuteTemplate(&buf, templateName, data)
	if err != nil {
		return fmt.Errorf("failed to execute template: %w", err)
	}

	formattedSourceCode, err := format.Source(buf.Bytes())
	if err != nil {
		return fmt.Errorf("failed to format go code: %w", err)
	}

	err = os.MkdirAll(filepath.Dir(targetPath), 0755)
	if err != nil {
		return fmt.Errorf("failed to create directory: %w", err)
	}

	err = os.WriteFile(targetPath, formattedSourceCode, 0644)
	if err != nil {
		return fmt.Errorf("failed to write file: %w", err)
	}

	w.logger.InfoContext(ctx, "success create file", "path", targetPath)
	return nil
}
