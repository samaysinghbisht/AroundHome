# Use the official NGINX base image
FROM nginx:alpine

# Copy the HTML file into the NGINX HTML directory
COPY app/index.html /usr/share/nginx/html

# Expose port 80 to make the app accessible
EXPOSE 80

# Start the NGINX server
CMD ["nginx", "-g", "daemon off;"]
