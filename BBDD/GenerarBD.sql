-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `Experimento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Experimento` (
  `id_experimento` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(45) NOT NULL,
  `fecha` DATE NOT NULL,
  `descripcion` LONGTEXT NULL,
  PRIMARY KEY (`id_experimento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `instrumento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `instrumento` (
  `id` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Experimento_has_Instrumento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Experimento_has_Instrumento` (
  `experimento_id_experimento` INT NOT NULL,
  `instrumento_id` INT NOT NULL,
  PRIMARY KEY (`experimento_id_experimento`, `instrumento_id`),
  CONSTRAINT `fk_experimento_has_instrumento_experimento`
    FOREIGN KEY (`experimento_id_experimento`)
    REFERENCES `Experimento` (`id_experimento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_experimento_has_instrumento_instrumento1`
    FOREIGN KEY (`instrumento_id`)
    REFERENCES `instrumento` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_experimento_has_instrumento_instrumento1_idx` ON `Experimento_has_Instrumento` (`instrumento_id` ASC) VISIBLE;

CREATE INDEX `fk_experimento_has_instrumento_experimento_idx` ON `Experimento_has_Instrumento` (`experimento_id_experimento` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `especie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `especie` (
  `id` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Experimento_has_especie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Experimento_has_especie` (
  `Experimento_id_experimento` INT NOT NULL,
  `especie_id` INT NOT NULL,
  PRIMARY KEY (`Experimento_id_experimento`, `especie_id`),
  CONSTRAINT `fk_Experimento_has_especie_Experimento1`
    FOREIGN KEY (`Experimento_id_experimento`)
    REFERENCES `Experimento` (`id_experimento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Experimento_has_especie_especie1`
    FOREIGN KEY (`especie_id`)
    REFERENCES `especie` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Experimento_has_especie_especie1_idx` ON `Experimento_has_especie` (`especie_id` ASC) VISIBLE;

CREATE INDEX `fk_Experimento_has_especie_Experimento1_idx` ON `Experimento_has_especie` (`Experimento_id_experimento` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Ensayo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ensayo` (
  `id_ensayo` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(45) NOT NULL,
  `descripcion` LONGTEXT NULL,
  `n_proteinas` INT NULL,
  `n_peptidos` INT NULL,
  `n_peptidos_unicos` INT NULL,
  `n_espectro_total` INT NULL,
  `n_espectro_identificado` INT NULL,
  `Experimento_id_experimento` INT NOT NULL,
  PRIMARY KEY (`id_ensayo`),
  CONSTRAINT `fk_Ensayo_Experimento1`
    FOREIGN KEY (`Experimento_id_experimento`)
    REFERENCES `Experimento` (`id_experimento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Ensayo_Experimento1_idx` ON `Ensayo` (`Experimento_id_experimento` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `revista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `revista` (
  `ISBN` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ISBN`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Publicacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Publicacion` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(255) NULL,
  `Experimento_id_experimento` INT NOT NULL,
  `revista_ISBN` VARCHAR(45) NOT NULL,
  `n_revista` INT NULL,
  `volumen` INT NULL,
  `pag_inicio` INT NULL,
  `pag_fin` INT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Publicacion_Experimento1`
    FOREIGN KEY (`Experimento_id_experimento`)
    REFERENCES `Experimento` (`id_experimento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Publicacion_revista1`
    FOREIGN KEY (`revista_ISBN`)
    REFERENCES `revista` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Publicacion_Experimento1_idx` ON `Publicacion` (`Experimento_id_experimento` ASC) VISIBLE;

CREATE INDEX `fk_Publicacion_revista1_idx` ON `Publicacion` (`revista_ISBN` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `instrumento_has_Ensayo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `instrumento_has_Ensayo` (
  `instrumento_id` INT NOT NULL,
  `Ensayo_id_ensayo` INT NOT NULL,
  PRIMARY KEY (`instrumento_id`, `Ensayo_id_ensayo`),
  CONSTRAINT `fk_instrumento_has_Ensayo_instrumento1`
    FOREIGN KEY (`instrumento_id`)
    REFERENCES `instrumento` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_instrumento_has_Ensayo_Ensayo1`
    FOREIGN KEY (`Ensayo_id_ensayo`)
    REFERENCES `Ensayo` (`id_ensayo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_instrumento_has_Ensayo_Ensayo1_idx` ON `instrumento_has_Ensayo` (`Ensayo_id_ensayo` ASC) VISIBLE;

CREATE INDEX `fk_instrumento_has_Ensayo_instrumento1_idx` ON `instrumento_has_Ensayo` (`instrumento_id` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
