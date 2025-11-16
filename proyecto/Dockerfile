#Usa la imagen base de nginx
FROM nginx:latest

#Copia el contenido del directorio web/ al directorio nginx
COPY web/ /usr/share/nginx/html/

#Expone el puerto 80
EXPOSE 80

#comando de inicio
CMD ["nginx", "-g", "daemon off;"]
