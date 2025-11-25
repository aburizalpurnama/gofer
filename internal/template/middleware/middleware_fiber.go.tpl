package {{ .PackageName }}

import (
	"log/slog"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

// RequestLogger initializes a middleware that injects a contextual logger into the request context
// and logs a summary of the request execution, including status code, latency, and errors.
func RequestLogger(logger *slog.Logger) fiber.Handler {
	return func(c *fiber.Ctx) error {
		start := time.Now()
		reqID := uuid.New().String()

		// Inject logger with request ID into context for downstream handlers
		// This allows subsequent layers (handlers, services) to log with the same request_id context.
		reqLogger := logger.With("request_id", reqID)
		c.Locals("logger", reqLogger)

		// Execute the next handler in the stack
		err := c.Next()

		// Calculate execution details
		latency := time.Since(start)
		statusCode := c.Response().StatusCode()
		clientIP := c.IP()

		// Check for explicit errors stored in context during handler execution
		// This pattern relies on handlers setting c.Locals("error", err) instead of just logging it.
		requestError := c.Locals("error")

		if requestError != nil {
			if e, ok := requestError.(error); ok {
				reqLogger.Error(
					"Request failed with an error",
					"method", c.Method(),
					"path", c.Path(),
					"status_code", statusCode,
					"latency_ms", latency.Milliseconds(),
					"client_ip", clientIP,
					"error", e.Error(),
				)
			}
		} else {
			// Log based on HTTP status severity
			if statusCode >= 500 {
				reqLogger.Error(
					"Request completed with server error",
					"method", c.Method(), "path", c.Path(), "status_code", statusCode,
					"latency_ms", latency.Milliseconds(), "client_ip", clientIP,
				)
			} else if statusCode >= 400 {
				reqLogger.Warn(
					"Request completed with client error",
					"method", c.Method(), "path", c.Path(), "status_code", statusCode,
					"latency_ms", latency.Milliseconds(), "client_ip", clientIP,
				)
			} else {
				reqLogger.Info(
					"Request handled successfully",
					"method", c.Method(), "path", c.Path(), "status_code", statusCode,
					"latency_ms", latency.Milliseconds(), "client_ip", clientIP,
				)
			}
		}

		return err
	}
}