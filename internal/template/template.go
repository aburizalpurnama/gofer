package template

import (
	"embed"
	"io/fs"
)

//go:embed *
var embeddedFiles embed.FS

// Content provides read-only access to all embedded files in this package
// as a standard fs.FS.
var Content fs.FS = embeddedFiles
