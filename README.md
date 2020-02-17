BigKahuna App

Api only app en ROR, se necesita tener instalado postgresql, para configurarlo se debe colocar el usuario y base de datos en   config/database.yml, luego instalar las gemas necesarias con bundle install.

luego ejecutar rake db:create y rake db:migrate, con esto se crearan las tablas necesarias para el api, para llenar las tablas con registros para pruebas ejecutar rake db:seed, esto creara usuarios comunes y administradores, asi como una serie de peliculas. 


