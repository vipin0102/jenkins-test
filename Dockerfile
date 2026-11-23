
# Use official Nginx image
FROM nginx:latest

# Remove default HTML files
RUN rm -rf /usr/share/nginx/html/*

# Copy custom website files
COPY index.html /usr/share/nginx/html/index.html

# Expose Nginx port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
