# Use official Node runtime
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Set production environment
ENV NODE_ENV=production

# Copy package files first (better caching)
COPY package*.json ./

# Install dependencies using lockfile for reproducible builds
# --omit=dev skips devDependencies (adjust if you need them at build time)
RUN npm ci --omit=dev

# Copy rest of the app
COPY . .

# Create a non-root user and give ownership of /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
	&& chown -R appuser:appgroup /app

USER appuser

# Expose the port Express uses
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
