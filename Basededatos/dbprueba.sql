-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 20-07-2021 a las 03:33:43
-- Versión del servidor: 10.4.20-MariaDB
-- Versión de PHP: 7.4.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `dbprueba`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `pa_menRolConsultar` (IN `_xFlag` TINYINT, IN `_xRol` VARCHAR(20))  BEGIN

	IF _xFlag='1' THEN									
		
        SELECT 
			rol,
            nombre,
            activo,
            estado
		FROM
		(
			SELECT 
				r.rol,
                r.nombre,
                r.activo,
				CASE r.activo
					WHEN '0' THEN 'INACTIVO'
					WHEN '1' THEN 'ACTIVO'
				END AS estado
			FROM men_rol r		
			ORDER BY r.nombre
		)R;						
	END IF;	
    
    IF _xFlag = '2' THEN
		 SELECT 
			rol,
            nombre,
            activo,
            estado
		FROM
		(
			SELECT 
				r.rol,
                r.nombre,
                r.activo,
				CASE r.activo
					WHEN '0' THEN 'INACTIVO'
					WHEN '1' THEN 'ACTIVO'
				END AS estado
			FROM men_rol r
			ORDER BY r.nombre
		)R WHERE nombre like concat('%',_xRol,'%');	 
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pa_menRolMantenimiento` (IN `_xFlag` CHAR(1), IN `_xRol` CHAR(4), IN `_xDescripcion` VARCHAR(100), IN `_xActivo` CHAR(4))  BEGIN
	DECLARE xDuplicado INT DEFAULT 0;
	DECLARE xResult VARCHAR(15) DEFAULT '';
    
    IF _xFlag = '1' THEN 
	BEGIN
		SELECT COUNT(*) INTO xDuplicado FROM men_rol WHERE nombre = _xDescripcion;
		IF xDuplicado = 0 THEN
			INSERT INTO men_rol(
				rol,
				nombre,
				activo
			)
			SELECT				
				LPAD(IF(MAX(rol) IS NULL = 1,1,MAX(rol)+1),4,0) AS rol,
				_xDescripcion,
				_xActivo
			FROM men_rol;
                
			SET xResult = 'MSG_0001'; -- Registro guardado
		ELSE 
			SET xResult = 'MSG_0005'; -- ya existe
		END IF;
        
        SELECT xResult AS result;
    END;
    END IF;
    
    IF _xFlag = '2' THEN
	BEGIN
		SELECT COUNT(*) INTO xDuplicado FROM men_rol WHERE nombre = _xDescripcion AND rol <> _xRol;
        
        IF xDuplicado = 0 THEN
			UPDATE men_rol
            SET
				nombre = _xDescripcion,
                activo = _xActivo
			WHERE rol = _xRol;
            
            SET xResult = 'MSG_0002'; -- Registro modificado
        ELSE
			SET xResult = 'MSG_0005'; -- ya existe
        END IF;
        
        SELECT xResult AS result;
    END;
    END IF;
    
	IF _xFlag = '3' THEN 
	BEGIN
		
		DELETE FROM men_rol WHERE rol = _xRol;
		SET xResult = 'MSG_0004'; -- Se elimino
        
        
	END;
	END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `men_rol`
--

CREATE TABLE `men_rol` (
  `rol` char(4) COLLATE utf8_spanish_ci NOT NULL,
  `nombre` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `activo` tinyint(4) DEFAULT 1,
  `accesodatosper` char(1) COLLATE utf8_spanish_ci DEFAULT '0',
  `accesocambiopwd` char(1) COLLATE utf8_spanish_ci DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `men_rol`
--

INSERT INTO `men_rol` (`rol`, `nombre`, `activo`, `accesodatosper`, `accesocambiopwd`) VALUES
('0001', 'ADMINISTRADOR', 1, '0', '1'),
('0002', 'SUPER ADMINISTRADOR', 1, '0', '1'),
('0003', 'USUARIO', 0, '0', '1');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `men_rol`
--
ALTER TABLE `men_rol`
  ADD PRIMARY KEY (`rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
