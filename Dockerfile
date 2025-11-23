# Use the official nginx base image
FROM nginx:latest

# Copy custom nginx configuration if needed
# COPY nginx.conf /etc/nginx/nginx.conf

# Copy static content to nginx html directory
# COPY ./html /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
