/*
Copyright © 2025 rizal_purnama <purnamar9@gmail.com>
*/
package cmd

import (
	"log/slog"

	"github.com/aburizalpurnama/gofer/internal/generator"
	"github.com/aburizalpurnama/gofer/internal/model"
	"github.com/aburizalpurnama/gofer/internal/writer"
	"github.com/spf13/cobra"
)

// generateCmd represents the generate command
var generateCmd = &cobra.Command{
	Use:   "generate",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	RunE: func(cmd *cobra.Command, args []string) error {
		// initiate db

		// inject dependencies

		logger := slog.Default()
		writer, err := writer.New(logger)
		if err != nil {
			return err
		}

		gen, err := generator.New(model.GORM, model.FIBER, logger, writer)
		if err != nil {
			return err
		}

		err = gen.Back.GenerateModel(cmd.Context(), "internal/app/model/product.go", model.ModelTemplateData{
			PackageName: "model",
			Imports:     []string{"github.com/test"},
			StructName:  "product",
			TableName:   "products",
			Fields: []model.TemplateField{
				{
					Name: "name",
					Type: "string",
					Tag:  `gorm:"column:name;notnull"`,
				},
			},
		})
		if err != nil {
			return err
		}

		// run builder

		return nil
	},
}

func init() {
	rootCmd.AddCommand(generateCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// generateCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// generateCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
