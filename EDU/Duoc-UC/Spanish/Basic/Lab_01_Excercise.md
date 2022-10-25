# Ejercicio

1. En su máquina virtual, haga doble clic en el icono **Azure Portal** para iniciar sesión. Puede obtener sus credenciales de usuario de Azure en la pestaña **Detalles del entorno**.

   ![image](../media/lab01-creds.png)

1. En la pestaña Iniciar sesión, ingrese su nombre de usuario y haga clic en **Siguiente**.

   ![image](../media/lab01-user-sign-in.png)

1. Introduzca la contraseña de su nombre de usuario y haga clic en **Iniciar sesión**.

   ![image](../media/lab01-sign-in-pass.png)

1. En la pestaña **Ayúdanos a proteger tu cuenta**, haz clic en **Omitir por ahora (14 días hasta que esto sea obligatorio)**.

   ![image](../media/lab01-sign-in-skip.png)

1. En la pestaña **¿Permanecer conectado?**, haga clic en **Sí**.

   ![image](../media/lab01-stay-signed-in.png)

1. En Azure Portal, busque Máquinas virtuales y verifique que el nombre del servidor sea **DC01**.
   
   ![image](../media/lab01b.png)
   
1. En Azure Portal, busque **Grupos de recursos**, seleccione su grupo de recursos y seleccione la IP pública de su servidor.

1. En la pestaña **Configuración**, haga clic en **Configuraciones** y verifique que la asignación de la dirección IP esté establecida en **Estático**.

   ![image](../media/lab01_pip.png)
   
1. En su VM, busque **Administrador de servidores** y en el Tablero haga clic en **Agregar funciones y funciones**.
   
   ![image](../media/lab01c.png)
   
1. Seleccione **Instalación basada en roles o funciones** como tipo de instalación y haga clic en **Siguiente**.
   
   ![image](../media/lab01_d.png)
   
1. En **Selección de servidor**, seleccione su servidor actual **DC01** como servidor de destino y haga clic en **Siguiente**.

   ![image](../media/lab01e.png)
   
1. En **Funciones de servidor**, marque la casilla de **Servicios de dominio de Active Directory** y haga clic en **Agregar funciones**.

   ![image](../media/lab01f.png)
   
   ![image](../media/lab01g.png)
   
1. En **Seleccionar funciones**, revise las funciones seleccionadas para AD DS y haga clic en **Siguiente**.

   ![image](../media/lab01-13.png)
   
1. En **Servicios de dominio de Active Directory**, revise la descripción general de los Servicios de dominio de Active Directory (AD DS) y haga clic en **Siguiente**.

   ![image](../media/lab01-14.png)

1. Confirme las selecciones de instalación en la pestaña **Confirmación** y haga clic en **Instalar**.

   ![image](../media/lab01h.png)
   
1. Espere a que se complete la instalación de la función y haga clic en **Promover este servidor a un controlador de dominio**.

   ![image](../media/lab01i.png)
   
1. En **Configuración de implementación**, seleccione **Agregar un nuevo bosque**, especifique el nombre de dominio raíz como **DUOC.CL** y haga clic en **Siguiente**.

   ![image](../media/lab01_j.png)
   
1. En **Opciones de controlador de dominio**, especifique la contraseña del Modo de restauración de servicios de directorio (DSRM) y haga clic en **Siguiente**.

   ![image](../media/lab01k.png)
   
1. En **Opciones de DNS**, ignore la advertencia y haga clic en **Siguiente**.

   ![image](../media/lab01l.png)
   
1. En **Opciones adicionales**, verifique que el nombre de dominio NetBIOS esté configurado como **DUOC** y haga clic en **Siguiente**.

   ![image](../media/lab01_m.png)
   
1. En **Rutas**, verifique que las rutas de la carpeta Base de datos, la carpeta Archivos de registro y la carpeta SYSVOL estén configuradas en **C:\Windows\NTDS**, **C:\Windows\NTDS** y ** C:\Windows\SYSVOL** respectivamente y haga clic en **Siguiente**.

   ![image](../media/lab01n.png)
   
1. Revise las opciones en la pestaña **Opciones de revisión** y haga clic en **Siguiente**.

   ![image](../media/lab01_o.png)
   
1. En **Comprobación de requisitos previos**, verifique que todas las comprobaciones de requisitos previos se hayan superado correctamente y haga clic en **Instalar**.

   ![image](../media/lab01_p.png)
   
1. Una vez que se completa la instalación, aparece un cuadro de diálogo emergente que dice **Está a punto de cerrar sesión** y su servidor se reiniciará.

   ![image](../media/lab01q.png)
   
1. Cuando se reinicie el servidor, espere a que se configure el cliente de directiva de grupo.

   ![image](../media/lab01r.png)
   
1. En su máquina virtual, busque **Administrador de servidores** y verifique que las funciones **AD DS** y **DNS** estén instaladas.

   ![image](../media/lab01s.png)
   
1. En **Administrador de servidores**, haga clic en **Herramientas** y seleccione **Usuarios y equipos de Active Directory**.

   ![image](../media/lab01t.png)
   
1. En **Usuarios y Equipos del Directorio Activo**, haga clic derecho sobre su dominio **DUOC.CL**, haga clic en **Nuevo** y seleccione **Unidad Organizacional**.

   ![image](../media/lab01u.png)
   
1. Asigne el nombre **Ventas** a su nueva unidad y haga clic en **Aceptar**.

   ![image](../media/lab01v.png)
   
1. De igual forma, siga los pasos 28 y 29 para crear dos Unidades más, **Soporte** y **Administración**.

   ![image](../media/lab01w.png)
   
1. En **Usuarios y Equipos del Directorio Activo**, haga clic derecho sobre su dominio **DUOC.CL**, haga clic en **Nuevo** y seleccione **Usuario**.

   ![image](../media/lab01x.png)
   
1. Ingrese las siguientes credenciales proporcionadas a continuación y haga clic en **Siguiente**.

   | Configuración | Valor |
   | --- | --- |
   | Nombre | **Juan** |
   | Apellido | **Pérez** |
   | Nombre completo | **Juan Pérez** |
   | User logon name | **Juan.Pérez** |

   ![image](../media/lab01y.png)
   
1. Ingrese una contraseña segura para el usuario, marque la casilla **El usuario debe cambiar la contraseña en el próximo inicio de sesión** y haga clic en **Siguiente**.

   ![image](../media/lab01z.png)
   
1. Revise las credenciales de usuario y haga clic en **Finalizar**.

   ![image](../media/lab01-z.png)
   
1. De igual forma, sigue los pasos del 31 al 34 para crear dos usuarios más, **Pedro González** y **Rodrigo Silva**.

   ![image](../media/lab01-ad-users.png)
   
1. En **Active Directory Users and Computers**, haga clic derecho en su dominio **DUOC.CL**, haga clic en **Nuevo** y seleccione **Grupo**.

   ![image](../media/lab01-grp.png)
   
1. Asigne al nuevo grupo el nombre **Administradores globales**, deje las demás configuraciones como predeterminadas y haga clic en **Aceptar**. 

   ![image](../media/lab01-grp-name.png)
   
   ![image](../media/lab01-ga-grp.png)
   
1. Abra el grupo **Administradores globales**, en la pestaña **Miembros**, haga clic en **Agregar**.

   ![image](../media/lab01-36.png)
   
1. En **Seleccione Usuarios, Contactos, Computadoras, Cuentas de servicio o Grupos**, busque **Juan** y haga clic en **Verificar nombres**.

   ![image](../media/lab01-37.png)
   
1. En **Seleccione Usuarios, Contactos, Computadoras, Cuentas de servicio o Grupos**, el nombre completo del usuario aparece con el nombre de inicio de sesión del usuario. Haga clic en Aceptar**.

   ![image](../media/lab01-38.png)
   
1. En **Propiedades de administradores globales**, verifique que el usuario esté agregado como miembro del grupo.

   ![image](../media/lab01-39.png)
   
1. De manera similar, siga los pasos del 38 al 40 para agregar otro miembro **Pedro González** y verifique que hay dos miembros agregados al grupo **Global Admins**.

   ![image](../media/lab01-40.png)
   
1. En **Propiedades de administradores globales**, cambie a la pestaña **Miembro de** y haga clic en **Agregar**.

   ![image](../media/lab01-41.png)
   
1. En **Seleccionar grupos**, busque **Admin** o **Administradores** y haga clic en **Comprobar nombres**.
   
   ![image](../media/lab01-42.png)
   
1. En **Seleccionar grupos**, aparece el grupo incorporado de **Administradores**. Haga clic en **Aceptar**.

   ![image](../media/lab01-43.png)
   
1. En **Propiedades de administradores globales**, verifique que **Administradores** sea miembro del grupo y haga clic en **Aceptar**.

   ![image](../media/lab01-44.png)
