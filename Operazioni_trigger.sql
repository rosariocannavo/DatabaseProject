--Di seguito tutte le operazioni e i trigger presenti all'interno della base di dati--

--T1 UN CLIENTE PUO' PRENDERE UN APPUNTAMENTO SOLO SE E' GIA' REGISTRATO--
CREATE TRIGGER `T1` AFTER INSERT ON `appuntamento`
FOR EACH ROW BEGIN
IF NOT EXISTS (SELECT *
               FROM cliente
               WHERE codice_fiscale = new.id_cliente)
THEN  
DELETE FROM appuntamento 
WHERE id_appuntamento = new.id_appuntamento;
END IF;
END

--OP.1 INSERISCI CLIENTE--
INSERT INTO `appuntamento` 
(`ID_cliente`, `ID_tatuatore`, `data/ora`, `bozza`) 
VALUES (74, 8, '1986-08-04 08:33:15', 0x687474703a2f2f6c6f72656d706978656c2e636f6d2f3630302f3430302f);

--OP.2 INSERISCI SEDUTA--
INSERT INTO `seduta` 
(`n_seduta`, `ore_seduta`, `ID_cliente`, `ID_tatuaggio`,
 `ID_tatuatore`) 
VALUES (1, 2, 197, 372, 2);

--OP.3 VISUALIZZA SPECIALIZZAZIONI--
SELECT `T.nome`, `T.cognome`, `S.nome_stile` 
FROM `tatuatore T`, `specializzato SP`, `stile S` 
WHERE `T.ID_tatuatore` = `SP.ID_tatuatore` 
AND `S.ID_stile` = `SP.ID_stile`;

--OP.4 VISUALIZZA TATUAGGI GIAPPONESI--
SELECT `T.immagine`, `T.note` 
FROM `tatuaggio T`, `stile S` 
WHERE `T.ID_stile` = `S.ID_stile` 
AND `S.nome_stile` = "Giapponese";

--OP.5 AGGIUNGI TATUGGIO--
INSERT INTO `tatuaggio` 
(`dimensione`, `posizione`, `immagine`, `ID_stile`,
 `note`, `indice_catalogo`) 
VALUES (76, 'Braccio', 
0x687474703a2f2f6c6f72656d706978656c2e636f6d2f3630302f3430302f, 8, "drago verde", NULL);

--OP.6 AGGIUNGI TATUATORE
INSERT INTO `tatuatore` (`nome`, `cognome`) 
VALUES ('Giovanni', 'Rana');

--OP.7 REGISTRA CLIENTE
INSERT INTO `cliente` (`nome`, `cognome`) 
VALUES (1, 'Francesco', 'Bergoglio');

--OP.8 NUMERO SEDUTE EFFETTUATE DA UN TATUATORE (senza ridondanza)
SELECT `T.nome`, `T.cognome`, COUNT(*) AS `numero_sedute` 
FROM `tatuatore T`, `seduta S` 
WHERE `T.ID_tatuatore` = `S.ID_tatuatore` 
GROUP BY `T.ID_tatuatore`;

--OP.8 NUMERO SEDUTE EFFETTUATE DA UN TATUATORE (con ridondanza)
SELECT T.numero_sedute_effettuate 
FROM tatuatore T;

--O9. VISUALIZZA STILE FREQUENTE
CREATE VIEW numero_tat AS
SELECT `S.nome_stile`, COUNT(*) AS `numeri`
FROM `tatuaggio T`, `stile S` 
WHERE `T.ID_stile` = `S.ID_stile`
GROUP BY `S.ID_stile`;

SELECT `N.nome_stile` 
FROM `numero_tat N` 
WHERE `N.numeri` = ( SELECT MAX(numeri) 
                     FROM `numero_tat`
                   );

--OP.10 VISUALIZZA TATUATORE CON TUTTE LE SPECIALIZZAZIONI
SELECT `T.nome`, `T.cognome`
FROM `tatuatore T`
WHERE NOT EXISTS(   SELECT * 
                    FROM `stile S`
                    WHERE NOT EXISTS(   SELECT *
                                        FROM `specializzato SP`
                                        WHERE `SP.iD_tatuatore` = `T.iD_tatuatore`
                                        AND   `SP.ID_stile` = `S.ID_stile`
                                    )
                );


