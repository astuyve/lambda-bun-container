# Builder image
FROM oven/bun:latest AS builder
WORKDIR /tmp
RUN apt-get update
RUN apt-get install curl unzip -y

# Fetch bun's lambda runtime
RUN curl https://raw.githubusercontent.com/oven-sh/bun/main/packages/bun-lambda/runtime.ts --output runtime.ts
COPY ./index.ts ./index.ts
RUN bun install aws4fetch
RUN bun build --compile runtime.ts --outfile bootstrap
RUN bun build --target=bun index.ts --outfile index

# Runtime image, includes Lambda RIC
FROM public.ecr.aws/lambda/provided:al2

# Copy our handler code into the task root
COPY --from=builder /tmp/index ${LAMBDA_TASK_ROOT}
# Copy bun + runtime.ts into the runtime directory
COPY --from=builder /tmp/bootstrap ${LAMBDA_RUNTIME_DIR}

# Set our handler method
CMD ["index.hello"]
