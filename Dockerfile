# Use the official lightweight NGINX image
FROM nginx:alpine

# Copy the HTML file to NGINX's default HTML directory
COPY app/index.html /usr/share/nginx/html

# Expose port 80 to make the app accessible
EXPOSE 80

# Start the NGINX server
CMD ["nginx", "-g", "daemon off;"]