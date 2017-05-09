-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 05-05-2017 a las 13:03:46
-- Versión del servidor: 5.7.17-0ubuntu0.16.04.1
-- Versión de PHP: 7.0.15-0ubuntu0.16.04.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `congress`
--
DROP database IF EXISTS `congress`;
CREATE database congress;
USE congress;
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE `usuarios` (
  `folio` int(8) NOT NULL,
  `nombreCompleto` varchar(145) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `username` varchar(20) DEFAULT NULL,
  `passw` varchar(45) DEFAULT NULL,
  `celular` varchar(45) DEFAULT NULL,
  `activo` int(11) NOT NULL DEFAULT '1',
  `Roles_idRoles` int(11) NOT NULL DEFAULT '2',
  `timestamp` TIMESTAMP DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`folio`, `nombreCompleto`, `email`, `username`, `passw`, `celular`, `activo`, `Roles_idRoles`, `timestamp`) VALUES
(16, 'Edgardo Morales Ontiveros ', 'emoron@gmail.com', '527578756', '', '4433605210', 0, 2, '2017-04-19 21:57:06'),
(17, 'Alejandra Esquivel Guillen', 'alejandraeg9899@gmail.com', '320077564', '', '4433830121', 0, 2, '2017-04-19 21:59:58'),
(18, 'Christian Morales Ontiveros ', 'chrosmora23@gmail.com', '379971886', '', '4433605210', 0, 2, '2017-04-21 13:23:30'),
(19, 'Edgardo Morales Ontiveros', 'laksdjasdjs@gmail.com', '831371000', '', '4433605210', 0, 2, '2017-04-21 13:35:10'),
(20, 'Edgardo Morales Ontiveros', 'pachito@gmail.com', '178900367', '', '4433605210', 0, 2, '2017-04-21 13:39:37'),
(21, 'skdjfhksjdhfks djfhk ', 'emorodd33enr@gmail.com', '89957518141663497050', '', '2323232323', 0, 2, '2017-04-23 13:49:16'),
(22, 'asdasdasdasdas', 'asdasdasdas@lwefwlkjf.docm', '54465761133558240895', '', '123123123123', 0, 2, '2017-04-23 14:35:35'),
(23, 'masjdajhksdja ksdjahsk djahs k', 'sdkfjjnsdjfkjsbndf@gndjskjd.com', '71410945446360830275', '', '28378928393827', 0, 2, '2017-04-23 14:36:47'),
(24, 'Edgardo Morales Ontiveros', 'sdkfjjnbndf@gndjskjd.com', '52550880721547249051', '', '2837892839', 0, 2, '2017-04-23 14:41:03');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`folio`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `folio` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
