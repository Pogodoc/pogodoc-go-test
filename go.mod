module github.com/Pogodoc/pogodoc-go-test

go 1.24

require (
	github.com/Pogodoc/pogodoc-go-test/client v0.1.0
	github.com/joho/godotenv v1.5.1
)

require github.com/google/uuid v1.4.0 // indirect

replace github.com/Pogodoc/pogodoc-go-test/client => ./client
