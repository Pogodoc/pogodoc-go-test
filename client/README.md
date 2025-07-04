# Pogodoc Go Library

[![fern shield](https://img.shields.io/badge/%F0%9F%8C%BF-Built%20with%20Fern-brightgreen)](https://buildwithfern.com?utm_source=github&utm_medium=github&utm_campaign=readme&utm_source=Pogodoc%2FGo)

The Pogodoc Go library provides convenient access to the Pogodoc API from Go.

## Usage

Instantiate and use the client with the following:

```go
package example

import (
    client "github.com/Pogodoc/pogodoc-go-test/client/client"
    option "github.com/Pogodoc/pogodoc-go-test/client/option"
    context "context"
    _client "github.com/Pogodoc/pogodoc-go-test/client"
)

func do() () {
    client := client.NewClient(
        option.WithToken(
            "<token>",
        ),
    )
    client.Templates.SaveCreatedTemplate(
        context.TODO(),
        "templateId",
        &_client.SaveCreatedTemplateRequest{
            TemplateInfo: &_client.SaveCreatedTemplateRequestTemplateInfo{
                Title: "title",
                Description: "description",
                Type: _client.SaveCreatedTemplateRequestTemplateInfoTypeDocx,
                SampleData: map[string]interface{}{
                    "sampleData": map[string]interface{}{
                        "key": "value",
                    },
                },
                Categories: []_client.SaveCreatedTemplateRequestTemplateInfoCategoriesItem{
                    _client.SaveCreatedTemplateRequestTemplateInfoCategoriesItemInvoice,
                    _client.SaveCreatedTemplateRequestTemplateInfoCategoriesItemInvoice,
                },
            },
            PreviewIds: &_client.SaveCreatedTemplateRequestPreviewIds{
                PngJobId: "pngJobId",
                PdfJobId: "pdfJobId",
            },
        },
    )
}
```

## Environments

You can choose between different environments by using the `option.WithBaseURL` option. You can configure any arbitrary base
URL, which is particularly useful in test environments.

```go
client := client.NewClient(
    option.WithBaseURL(pogodoc.Environments.Default),
)
```

## Errors

Structured error types are returned from API calls that return non-success status codes. These errors are compatible
with the `errors.Is` and `errors.As` APIs, so you can access the error like so:

```go
response, err := client.Templates.SaveCreatedTemplate(...)
if err != nil {
    var apiError *core.APIError
    if errors.As(err, apiError) {
        // Do something with the API error ...
    }
    return err
}
```

## Request Options

A variety of request options are included to adapt the behavior of the library, which includes configuring
authorization tokens, or providing your own instrumented `*http.Client`.

These request options can either be
specified on the client so that they're applied on every request, or for an individual request, like so:

> Providing your own `*http.Client` is recommended. Otherwise, the `http.DefaultClient` will be used,
> and your client will wait indefinitely for a response (unless the per-request, context-based timeout
> is used).

```go
// Specify default options applied on every request.
client := client.NewClient(
    option.WithToken("<YOUR_API_KEY>"),
    option.WithHTTPClient(
        &http.Client{
            Timeout: 5 * time.Second,
        },
    ),
)

// Specify options for an individual request.
response, err := client.Templates.SaveCreatedTemplate(
    ...,
    option.WithToken("<YOUR_API_KEY>"),
)
```

## Advanced

### Retries

The SDK is instrumented with automatic retries with exponential backoff. A request will be retried as long
as the request is deemed retryable and the number of retry attempts has not grown larger than the configured
retry limit (default: 2).

A request is deemed retryable when any of the following HTTP status codes is returned:

- [408](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/408) (Timeout)
- [429](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/429) (Too Many Requests)
- [5XX](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/500) (Internal Server Errors)

Use the `option.WithMaxAttempts` option to configure this behavior for the entire client or an individual request:

```go
client := client.NewClient(
    option.WithMaxAttempts(1),
)

response, err := client.Templates.SaveCreatedTemplate(
    ...,
    option.WithMaxAttempts(1),
)
```

### Timeouts

Setting a timeout for each individual request is as simple as using the standard context library. Setting a one second timeout for an individual API call looks like the following:

```go
ctx, cancel := context.WithTimeout(ctx, time.Second)
defer cancel()

response, err := client.Templates.SaveCreatedTemplate(ctx, ...)
```

## Contributing

While we value open-source contributions to this SDK, this library is generated programmatically.
Additions made directly to this library would have to be moved over to our generation code,
otherwise they would be overwritten upon the next generated release. Feel free to open a PR as
a proof of concept, but know that we will not be able to merge it as-is. We suggest opening
an issue first to discuss with us!

On the other hand, contributions to the README are always very welcome!