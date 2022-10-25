# Curso 03: Configure Replicación de Active Directory en Windows Server 2016

1. En su máquina virtual, busque **Administrador de servidores**, haga clic en **Herramientas** y seleccione **Usuarios y equipos de Active Directory**.

   ![image](../media/lab01t.png)
   
1. En **Usuarios y Equipos del Directorio Activo**, haga clic derecho en su dominio **CCU.CL**, haga clic en **Nuevo** y seleccione **Unidad Organizacional**.

   ![image](../media/lab03-2.png)
   
1. Asigne el nombre **Duoc** a su nueva unidad organizativa y haga clic en **Aceptar**.*.

   ![image](../media/lab03-3.png)
   
1. En **Usuarios y equipos de Active Directory**, haga clic derecho en su unidad organizativa **Duoc**, haga clic en **Nuevo** y seleccione **Usuario**.

   ![image](../media/lab03-4.png)
   
1. Ingrese **duocano** para **Nombre** y **Nombre de inicio de sesión de usuario** y haga clic en **Siguiente**.

   ![image](../media/lab03-5.png)
   
1. Ingrese una contraseña segura para el usuario, marque la casilla **El usuario debe cambiar la contraseña en el próximo inicio de sesión** y haga clic en **Siguiente**.

   ![image](../media/lab03-6.png)
   
1. Revise las credenciales de usuario y haga clic en **Finalizar**.

   ![image](../media/lab03-7.png)
   
1. En **Active Directory Users and Computers**, verifique que el usuario **duocano** esté creado dentro de la Unidad Organizativa **Duoc**.

   ![image](../media/lab03-8.png)
   
1. En su máquina virtual, haga doble clic en el icono **Azure Portal** para iniciar sesión. Puede obtener sus credenciales de usuario de Azure en la pestaña **Detalles del entorno**.

   ![image](../media/lab03-9.png)
   
1. En la pestaña Iniciar sesión, ingrese su nombre de usuario y haga clic en **Siguiente**.

   ![image](../media/lab01-user-sign-in.png)
   
1. Introduzca la contraseña de su nombre de usuario y haga clic en **Iniciar sesión**.

   ![image](../media/lab01-sign-in-pass.png)
   
1. En la pestaña **Ayúdanos a proteger tu cuenta**, haz clic en **Omitir por ahora (14 días hasta que esto sea obligatorio)**.

   ![image](../media/lab01-sign-in-skip.png)

1. En la pestaña **¿Permanecer conectado?**, haga clic en **Sí**.

   ![image](../media/lab01-stay-signed-in.png)
   
1. En Azure Portal, busque Máquinas virtuales y conéctese a su máquina virtual **DC02** a través de **RDP**.

1. En **DC02**, busque **Explorador de archivos**, haga clic derecho en **Red** y haga clic en **Propiedades**.

   ![image](../media/lab03-15.png)
   
1. En **Centro de redes y recursos compartidos**, haga clic en **Ethernet**.

   ![image](../media/lab03-16.png)
   
1. En **Estado de Ethernet**, haga clic en **Propiedades**.

   ![image](../media/lab03-17.png)
   
1. En **Propiedades de Ethernet**, seleccione **Protocolo de Internet versión 4 (TCP/IPv4)**.

   ![image](../media/lab03-18.png)
   
1. En **Propiedades del Protocolo de Internet versión 4 (TCP/IPv4)**, seleccione **Usar la siguiente dirección IP**, especifique el siguiente rango de direcciones y haga clic en **Aceptar**.

   | Configuración | Valor |
   | --- | --- |
   | IP address | **10.0.0.5** |
   | Subnet mask | **255.0.0.0** |
   | Default gateway | **10.0.0.1** |
   | Preferred DNS server | **10.0.0.4** |
   
   ![image](../media/lab03-19.png)
   
1. En **DC02**, busque **Administrador de servidores**, vaya a la pestaña **Servidor local** y haga clic en el nombre de la computadora **DC02**.

   ![image](../media/lab03-20.png)
   
1. En **Propiedades del sistema**, haga clic en **Cambiar**.
   
   ![image](../media/lab03-21.png)
   
1. En **Cambios de dominio/nombre de equipo**, seleccione **Dominio**, ingrese **ccu.cl** y haga clic en **Aceptar**.

   ![image](../media/lab03-22.png)
   
1. Ingrese sus credenciales de administrador y haga clic en **Aceptar**. Puede obtener sus credenciales de usuario de Azure en la pestaña **Detalles del entorno**.

   ![image](../media/lab03-23.png)
   
1. Aparecerá una ventana emergente que especifica que el servidor secundario está unido al dominio **ccu.cl**. Una vez que haga clic en **Aceptar**, aparecerá otra ventana emergente que le indicará que reinicie la computadora para aplicar los cambios. Haga clic en Aceptar**.

   ![image](../media/lab03-24a.png)
   
   ![image](../media/lab03-24b.png)
   
1. Cuando aparezca la ventana emergente de **Microsoft Windows** indicándole que reinicie su computadora, haga clic en **Reiniciar ahora**.

   ![image](../media/lab03-25.png)
   
1. Vaya a Azure Portal, busque Máquinas virtuales y conéctese a su máquina virtual **DC02** a través de **RDP** una vez que se haya reiniciado.

1. En **DC02**, busque **Administrador de servidores**, vaya a la pestaña **Servidor local** y verifique que el dominio de DC02 sea **ccu.cl**.

   ![image](../media/lab03-27.png)
   
1. En **Administrador de servidores**, vuelva a Dashboard y haga clic en **Agregar funciones y funciones**.

   ![image](../media/lab01c.png)
   
1. Select **Role-based or feature-based installation** as the installation type and click **Next**.

   ![image](../media/lab03-29.png)
   
1. Seleccione **Instalación basada en roles o funciones** como tipo de instalación y haga clic en **Siguiente**.

   ![image](../media/lab03-30.png)
   
1. En **Funciones de servidor**, marque la casilla de **Servicios de dominio de Active Directory** y haga clic en **Agregar funciones**.

   ![image](../media/lab03-31a.png)
   
   ![image](../media/lab03-31b.png)
   
1. En **Seleccionar funciones**, revise las funciones seleccionadas para AD DS y haga clic en **Siguiente**.

   ![image](../media/lab03-32.png)
   
1. En **Servicios de dominio de Active Directory**, revise la descripción general de los Servicios de dominio de Active Directory (AD DS) y haga clic en **Siguiente**.

   ![image](../media/lab03-33.png)
   
1. Confirme las selecciones de instalación en la pestaña **Confirmación** y haga clic en **Instalar**.

   ![image](../media/lab03-34.png)
   
1. Espere a que se complete la instalación de la función y haga clic en **Promover este servidor a un controlador de dominio**.

   ![image](../media/lab03-35.png)
   
1. En **Configuración de implementación**, seleccione **Agregar un controlador de dominio a un dominio existente** y haga clic en **Cambiar**. Ingrese el nombre de usuario **azureuser@ccu.cl**, proporcione su contraseña de administrador y haga clic en **Aceptar**. Puede obtener su contraseña de administrador de vm en la pestaña **Detalles del entorno**.

   ![image](../media/lab03-36a.png)
   
   ![image](../media/lab03-36b.png)

1. En **Opciones de controlador de dominio**, especifique la contraseña del Modo de restauración de servicios de directorio (DSRM) y haga clic en **Siguiente**.

   ![image](../media/lab03-37.png)
   
1. En **Opciones de DNS**, ignore la advertencia y haga clic en **Siguiente**.

   ![image](../media/lab03-38.png)
   
1. En **Opciones adicionales**, seleccione **DC01.ccu.cl** del menú desplegable para la replicación y haga clic en **Siguiente**.

   ![image](../media/lab03-39.png)
   
1. En **Rutas**, verifique que las rutas de la carpeta Base de datos, la carpeta Archivos de registro y la carpeta SYSVOL estén configuradas en **C:\Windows\NTDS**, **C:\Windows\NTDS** y ** C:\Windows\SYSVOL** respectivamente y haga clic en **Siguiente**.

   ![image](../media/lab03-40.png)
   
1. Revise sus selecciones en la pestaña **Opciones de revisión** y haga clic en **Siguiente**.

   ![image](../media/lab03-41.png)
   
1. En **Comprobación de requisitos previos**, verifique que todas las comprobaciones de requisitos previos se hayan superado correctamente y haga clic en **Instalar**.

   ![image](../media/lab03-42.png)
   
1. Una vez que se completa la instalación, aparece una ventana emergente que dice **Está a punto de cerrar sesión** y su servidor se reiniciará.

   ![image](../media/lab03-43.png)
   
1. En **DC02**, busque **Administrador del servidor** y verifique que las funciones **AD DS** y **DNS** estén instaladas.

   ![image](../media/lab01s.png)
   
1. Para verificar que la replicación de AD se realizó correctamente, en **Administrador de servidores**, haga clic en **Herramientas** y seleccione **Usuarios y equipos de Active Directory**.
   
   ![image](../media/lab01t.png)
   
1. En **Usuarios y equipos de Active Directory**, debería poder ver la unidad organizativa **Duoc** y un usuario llamado **duocano** creado en su servidor principal **DC01**.

   ![image](../media/lab03-46.png)
