package generator

import (
	"fmt"

	"github.com/aburizalpurnama/gofer/internal/contract"
	"github.com/aburizalpurnama/gofer/internal/model"
)

type generator struct {
	front   contract.FrontLayerGenerator
	service contract.ServiceLayerGenerator
	back    contract.BackLayerGenerator
}

func New(DBLibrary model.DBLibrary, webFramework model.WebFramerowk) (*generator, error) {
	var frontGen contract.FrontLayerGenerator
	switch webFramework {
	case model.FIBER:
		frontGen = newfiberGenerator()
	case model.GIN:
	case model.CHI:
	default:
		return nil, fmt.Errorf("invalid Web Framework")

	}

	var backGen contract.BackLayerGenerator
	switch DBLibrary {
	case model.GORM:
		backGen = newGormGenerator()
	case model.SQLX:
	default:
		return nil, fmt.Errorf("invalid DBLibrary")
	}

	serviceGen := newserviceGenerator()

	return &generator{
		front:   frontGen,
		service: serviceGen,
		back:    backGen,
	}, nil
}
