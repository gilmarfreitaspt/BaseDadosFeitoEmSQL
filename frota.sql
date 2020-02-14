-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 13-Fev-2020 às 19:36
-- Versão do servidor: 10.4.6-MariaDB
-- versão do PHP: 7.3.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `frota`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AlterarDisponibilidadeMotorista` (IN `var_m_cc` INT)  NO SQL
UPDATE  motorista
set m_disp = 1 
WHERE m_cc = var_m_cc$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AtualizaKmVeiculo` ()  NO SQL
UPDATE veiculo
inner join servico on servico.S_V_MAT  = veiculo.v_mat
inner join motorista on motorista.m_cc = servico.S_M_CC
set veiculo.v_km = servico.S_KM_FINAL, 
veiculo.v_disp = 1, 
motorista.m_disp = 1
WHERE veiculo.v_km < servico.S_KM_FINAL$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarVeiculoMatricula` (IN `var_mat` VARCHAR(10))  NO SQL
DELETE FROM veiculo
WHERE veiculo.v_mat = var_mat$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `LimpaTabelaTipo` ()  NO SQL
TRUNCATE TABLE tipo$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarCartasCaducada` ()  NO SQL
SELECT m_nome, m_validade_carta FROM motorista
WHERE (m_validade_carta < CURRENT_DATE)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarMotoristaDisponivelPorLocal` (IN `var_Local` VARCHAR(30))  NO SQL
SELECT * FROM motorista WHERE m_local 
LIKE var_Local and m_disp = 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarMotoristasDisponiveis` ()  NO SQL
SELECT * FROM motorista WHERE(m_disp)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarVeiculosDisponivel` ()  NO SQL
SELECT * FROM veiculo WHERE (v_disp = 1)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarVeiculosPorTipo` ()  NO SQL
SELECT veiculo.v_mat as 'Matricula',veiculo.v_marca, veiculo.v_km, tipo.t_des
FROM veiculo, tipo

WHERE veiculo.v_t_cod = tipo.t_cod
ORDER by v_t_cod$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `MotoristaNotDisp` ()  NO SQL
SELECT * FROM motorista WHERE(m_disp=0)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RotinaAlterarMCC` ()  NO SQL
UPDATE motorista
SET m_disp = 0
WHERE m_validade_carta < CURRENT_DATE$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RotinaAtualizaServicoKMInicial` ()  NO SQL
UPDATE  servico
INNER JOIN veiculo on servico.S_V_MAT = veiculo.v_mat

set S_KM_INICIAL = veiculo.v_km

WHERE S_KM_INICIAL < servico.S_KM_FINAL$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `motorista`
--

CREATE TABLE `motorista` (
  `m_cc` int(11) NOT NULL,
  `m_nome` varchar(30) DEFAULT NULL,
  `m_disp` tinyint(1) DEFAULT NULL,
  `m_validade_carta` date DEFAULT NULL,
  `m_local` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `motorista`
--

INSERT INTO `motorista` (`m_cc`, `m_nome`, `m_disp`, `m_validade_carta`, `m_local`) VALUES
(1, 'Alexandre Vitor Simões Bernard', 0, '2020-03-15', 'Porto'),
(2, 'Ana Passos', 1, '2030-11-02', 'Porto'),
(3, 'Carlos Sottomayor', 0, '2022-02-15', 'Porto'),
(4, 'Carlos Campos', 0, '2032-06-22', 'Porto'),
(5, 'Miguel Carreira', 0, '2040-07-02', 'Porto'),
(6, 'Daniel Francisco', 1, '2040-08-02', 'Porto'),
(7, 'Gilmar Freitas', 1, '2040-11-30', 'Vila nova de Gaia'),
(8, 'Isabela  Macena', 0, '2040-11-02', 'Porto'),
(9, 'Jaime Soares', 0, '2040-10-20', 'Porto'),
(10, 'Luís Pacheco', 1, '2040-12-22', 'Maia'),
(11, 'Pedro Ferreira', 0, '2030-08-02', 'Porto'),
(12, 'Pedro Ribeiro', 0, '2045-09-02', 'Porto'),
(13, 'Ricardo Santos', 1, '2049-12-02', 'Porto'),
(14, 'Rui Barros', 0, '2040-02-02', 'Porto'),
(15, 'Vitor Ramos', 0, '2040-07-02', 'Porto'),
(16, 'Paulo Borges', 0, '2020-02-02', 'Porto');

-- --------------------------------------------------------

--
-- Estrutura da tabela `servico`
--

CREATE TABLE `servico` (
  `S_ID` int(11) NOT NULL,
  `S_DATA_INICIO` date DEFAULT NULL,
  `S_V_MAT` varchar(10) DEFAULT NULL,
  `S_M_CC` int(11) DEFAULT NULL,
  `S_KM_INICIAL` int(11) NOT NULL,
  `S_KM_FINAL` int(11) NOT NULL,
  `S_DATA_FINAL` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `servico`
--

INSERT INTO `servico` (`S_ID`, `S_DATA_INICIO`, `S_V_MAT`, `S_M_CC`, `S_KM_INICIAL`, `S_KM_FINAL`, `S_DATA_FINAL`) VALUES
(1, '2020-01-04', '00-AA-00', 3, 12500, 12500, '2020-01-13'),
(2, '2020-01-08', '00-SS-00', 2, 18000, 18000, '2020-01-18'),
(3, '2020-01-18', '00-AA-00', 5, 12002, 12002, '2020-02-13'),
(4, '2020-01-22', '00-FF-00', 3, 18000, 0, '0000-00-00'),
(5, '2020-01-25', '00-SS-00', 7, 18000, 0, '0000-00-00'),
(6, '2020-01-31', '00-XX-00', 7, 49000, 49000, '2020-02-13'),
(7, '2020-02-09', '00-PP-00', 12, 38000, 0, '0000-00-00'),
(8, '2020-02-11', '00-JJ-00', 15, 22020, 22020, '2020-02-13'),
(9, '2020-02-14', '00-ZZ-00', 14, 35450, 35450, '2020-02-13'),
(10, '2020-02-18', '00-II-00', 8, 19000, 19000, '2020-02-13'),
(11, '2020-02-19', '00-CC-00', 11, 18920, 18920, '2020-02-13'),
(12, '2020-02-18', '00-EE-00', 4, 18000, 0, '0000-00-00'),
(13, '2020-01-04', '00-BB-00', 1, 18000, 0, '0000-00-00');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tipo`
--

CREATE TABLE `tipo` (
  `t_cod` int(11) NOT NULL,
  `t_des` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `tipo`
--

INSERT INTO `tipo` (`t_cod`, `t_des`) VALUES
(1, 'Familiar'),
(2, 'Comercial'),
(3, 'Pesado');

-- --------------------------------------------------------

--
-- Estrutura da tabela `veiculo`
--

CREATE TABLE `veiculo` (
  `v_mat` varchar(10) NOT NULL,
  `v_marca` varchar(30) NOT NULL,
  `v_km` int(11) DEFAULT NULL,
  `v_disp` tinyint(1) DEFAULT NULL,
  `v_t_cod` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `veiculo`
--

INSERT INTO `veiculo` (`v_mat`, `v_marca`, `v_km`, `v_disp`, `v_t_cod`) VALUES
('00-AA-00', 'FORD MONDEO', 12500, 1, 1),
('00-BB-00', 'FORD FIESTA', 18000, 0, 2),
('00-CC-00', 'RENAULT CLIO', 18920, 1, 2),
('00-EE-00', 'VW PASSAT', 18000, 0, 1),
('00-FF-00', 'OPEL ASTRA', 18000, 0, 1),
('00-II-00', 'VOLVO PEGA MONSTRO', 19000, 1, 3),
('00-JJ-00', 'VOLVO PESADOTE', 22020, 1, 3),
('00-PP-00', 'RENAULT MEGANE', 38000, 0, 1),
('00-SS-00', 'VOLVO 10T', 18000, 0, 3),
('00-XX-00', 'OPEL CORSA', 49000, 0, 2),
('00-ZZ-00', 'OPEL ZAFIRA', 35450, 0, 1);

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `motorista`
--
ALTER TABLE `motorista`
  ADD PRIMARY KEY (`m_cc`);

--
-- Índices para tabela `servico`
--
ALTER TABLE `servico`
  ADD PRIMARY KEY (`S_ID`),
  ADD KEY `S_V_MAT` (`S_V_MAT`),
  ADD KEY `S_M_CC` (`S_M_CC`);

--
-- Índices para tabela `tipo`
--
ALTER TABLE `tipo`
  ADD PRIMARY KEY (`t_cod`);

--
-- Índices para tabela `veiculo`
--
ALTER TABLE `veiculo`
  ADD PRIMARY KEY (`v_mat`),
  ADD KEY `v_t_cod` (`v_t_cod`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `servico`
--
ALTER TABLE `servico`
  MODIFY `S_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de tabela `tipo`
--
ALTER TABLE `tipo`
  MODIFY `t_cod` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `servico`
--
ALTER TABLE `servico`
  ADD CONSTRAINT `servico_ibfk_1` FOREIGN KEY (`S_V_MAT`) REFERENCES `veiculo` (`v_mat`),
  ADD CONSTRAINT `servico_ibfk_2` FOREIGN KEY (`S_M_CC`) REFERENCES `motorista` (`m_cc`);

--
-- Limitadores para a tabela `veiculo`
--
ALTER TABLE `veiculo`
  ADD CONSTRAINT `veiculo_ibfk_1` FOREIGN KEY (`v_t_cod`) REFERENCES `tipo` (`t_cod`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
