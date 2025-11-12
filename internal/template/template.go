package template

import (
	"embed"
	"io/fs"
)

//go:embed files
var embeddedFiles embed.FS

// Content provides read-only access to all embedded files in this package
// as a standard fs.FS.
var Content fs.FS = embeddedFiles

func init() {
	fsys, err := fs.Sub(embeddedFiles, "files")
	if err != nil {
		panic(err)
	}

	Content = fsys
}
