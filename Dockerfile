# Use lightweight nginx image
FROM nginx:stable-alpine

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy your prebuilt dist folder into nginx web root
COPY dist/ /usr/share/nginx/html

# Expose port 3000 (nginx will listen here)
EXPOSE 3000

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

