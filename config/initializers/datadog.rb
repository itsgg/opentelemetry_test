require 'opentelemetry/sdk'
require 'opentelemetry-exporters-datadog'

span_processor = OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(
  OpenTelemetry::SDK::Trace::Export::ConsoleSpanExporter.new
)

OpenTelemetry::SDK.configure do |c|
  c.use 'OpenTelemetry::Instrumentation::Rails'
  c.use 'OpenTelemetry::Instrumentation::GraphQL'

  c.add_span_processor(span_processor)
  c.add_span_processor(
    OpenTelemetry::Exporters::Datadog::DatadogSpanProcessor.new(
      exporter: OpenTelemetry::Exporters::Datadog::Exporter.new(
        service_name: 'my-app', agent_url: 'http://localhost:8126'
      )
    )
  )
end

OpenTelemetry::Exporters::Datadog::Propagator.auto_configure
