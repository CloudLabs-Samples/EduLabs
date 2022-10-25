# Ejercicio

1. En su máquina virtual, haga doble clic en el icono **Azure Portal** para iniciar sesión. Puede obtener sus credenciales de usuario de Azure en la pestaña **Detalles del entorno**.

   ![image](../media/lab02-1.png)
  
1. En la pestaña Iniciar sesión, ingrese su nombre de usuario y haga clic en **Siguiente**.

   ![image](../media/lab01-user-sign-in.png)

1. Introduzca la contraseña de su nombre de usuario y haga clic en **Iniciar sesión**.

   ![image](../media/lab01-sign-in-pass.png)

1. En la pestaña **Ayúdanos a proteger tu cuenta**, haz clic en **Omitir por ahora (14 días hasta que esto sea obligatorio)**.

   ![image](../media/lab01-sign-in-skip.png)

1. En la pestaña **¿Permanecer conectado?**, haga clic en **Sí**.

   ![image](../media/lab01-stay-signed-in.png)
   
1. En Azure Portal, busque Virtual Machines y verifique que haya dos máquinas virtuales, **DC01** y **WindowsClient**.

   ![image](../media/lab02-6.png)
   
1. Haga clic en **DC01** y verifique que la **Dirección IP privada** sea **10.0.0.4**.

   ![image](../media/lab02-7.png)
   
1. Vuelva a cambiar a Máquinas virtuales, haga clic en **WindowsClient** y verifique que la **Dirección IP privada** sea **10.0.0.5**.

   ![image](../media/lab02-8.png)
   
1. En su VM, busque **Administrador de servidores** y en el Tablero haga clic en **Agregar funciones y funciones**.
   
   ![image](../media/lab01c.png)
   
1. Seleccione **Instalación basada en roles o funciones** como tipo de instalación y haga clic en **Siguiente**.
   
   ![image](../media/lab01_d.png)
   
1. En **Selección de servidor**, seleccione su servidor actual **DC01** como servidor de destino y haga clic en **Siguiente**.

   ![image](../media/lab01e.png)
   
1. En **Funciones de servidor**, marque la casilla de **Servidor web (IIS)** y haga clic en **Agregar funciones**.

   ![image](../media/lab02-12a.png)
   
   ![image](../media/lab02-12b.png)
   
1. En **Seleccionar características**, expanda **Características de .NET Framework 4.6**, marque la casilla de **ASP.NET 4.6**. En **Características de .NET Framework 4.6**, expanda **Servicios WCF**, marque la casilla de **Activación HTTP** y haga clic en **Agregar características**.

   ![image](../media/lab02-13a.png)
   
   ![image](../media/lab02-13b.png)
   
1. En **Seleccionar funciones**, expanda **.NET Framework 3.5 Funciones**, marque la casilla de **Activación HTTP** y haga clic en **Agregar funciones**.

   ![image](../media/lab02-14a.png)
   
   ![image](../media/lab02-14b.png)
   
1. En **Seleccionar funciones**, revise las funciones seleccionadas y haga clic en **Siguiente**.

   ![image](../media/lab02-15.png)
   
1. En **Rol de servidor web (IIS)**, revise la descripción general de Rol de servidor web (IIS) y haga clic en **Siguiente**.

   ![image](../media/lab02-16.png)
   
1. En **Seleccionar servicios de función**, expanda **Seguridad** y marque la casilla de **Autenticación de Windows**.

   ![image](../media/lab02-18.png)
   
1. En **Seleccionar servicios de función**, expanda **Desarrollo de aplicaciones** y marque la casilla de **ASP.NET 3.5**.
   
   ![image](../media/lab02-19.png)
   
1. En **Seleccionar servicios de rol**, verifique que los siguientes servicios estén seleccionados y haga clic en **Siguiente**

   * Common HTTP Features
      * Default Document
      * Directory Browsing
      * HTTP Errors
      * Static Content
   * Securiy
      * Request Filtering
      * Windows Authentication
   * Application Development
      * .NET Extensibility 3.5
      * .NET Extensibility 4.6
      * ASP.NET 3.5
      * ASP.NET 4.6
      * ISAPI Extensions
      * ISAPI Filters
    * Management Tools
      * IIS Management Console
   
   ![image](../media/lab02-20.png)
   
1. Espere a que se complete la instalación de la función y haga clic en **Cerrar**.

   ![image](../media/lab02-21.png)
   
1. En **Administrador de servidores**, verifique que la función **IIS** esté instalada.

   ![image](../media/lab02-22.png)
   
1. In **Server Manager**, verify that the **IIS** feature is installed.

   ![image](../media/lab02-23.png)
   
1. En Azure Portal, busque Virtual Machines y conéctese a su máquina virtual **WindowsClient** a través de **RDP**.

1. En su máquina virtual **WindowsClient**, abra Microsoft Edge, busque **http://10.0.0.4** y verifique que el servidor web que instaló en su DC01 se esté ejecutando.

   ![image](../media/lab02-25.png)
