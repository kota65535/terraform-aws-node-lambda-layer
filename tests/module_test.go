package tests

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestModule(t *testing.T) {
	// Arrange
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples",
	}

	// Act
	terraform.InitAndApply(t, terraformOptions)

	// Assert
	actual := make(map[string]interface{}, 0)
	terraform.OutputStruct(t, terraformOptions, "lambda_layer", &actual)
	assert.Equal(t, actual["layer_name"], "test")
	assert.Equal(t, actual["compatible_runtimes"], []interface{}{"nodejs20.x"})
}
