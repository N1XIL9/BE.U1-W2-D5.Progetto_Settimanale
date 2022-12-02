USE GestioneContravvenzioni

CREATE TABLE Anagrafica (
	IDAnagrafica INT IDENTITY NOT NULL PRIMARY KEY,
	Cognome NVARCHAR(20) NOT NULL,
	Nome NVARCHAR(20) NOT NULL,
	Indirizzo NVARCHAR (40) NOT NULL,
	Citta NVARCHAR(20) NOT NULL,
	CAP CHAR(5),
	CodiceFiscale CHAR(16) NOT NULL
)

CREATE TABLE TipoViolazione (
	IDViolazione INT IDENTITY NOT NULL PRIMARY KEY,
	Descrizione NVARCHAR(300) NOT NULL
)

CREATE TABLE Verbale (
	IDVerbale INT IDENTITY NOT NULL PRIMARY KEY,
	DataViolazione DATETIME NOT NULL,
	IndirizzoViolazione NVARCHAR(50) NOT NULL,
	NominativoAgente NVARCHAR(20),
	DataTrascizioneVerbale DATETIME NOT NULL,
	Importo MONEY NOT NULL,
	DecurtamentoPunti TINYINT NOT NULL,
	IDViolazione INT NOT NULL,
	IDAnagrafica INT NOT NULL


	CONSTRAINT PK_Verbale_TipoViolazione FOREIGN KEY (IDViolazione) REFERENCES TipoViolazione (IDViolazione),
	CONSTRAINT PK_Verbale_Anagrafica FOREIGN KEY (IDAnagrafica) REFERENCES Anagrafica (IDAnagrafica)
)



INSERT INTO Anagrafica VALUES ('Lerra', 'Nicola', 'Viale della liberta', 'Nova Siri', '75020', 'LRRNCL91D04G657M')
INSERT INTO Anagrafica VALUES ('Pistoia', 'Gino', 'Viale della Menzogna', 'Gotham', '11131', 'PSSTO32462736G')
INSERT INTO Anagrafica VALUES ('Velotti', 'Carmelo', 'Viale della rinascita', 'Tomorrowland', '45664', 'JJHGJ374673673H')
INSERT INTO Anagrafica VALUES ('Stano', 'Bruno', 'Viale del carcere', 'Brindisi', '13211', 'BRRST22637G675M')
INSERT INTO Anagrafica VALUES ('De Filippo', 'Daniela', 'Viale della Nonmiricordo', ' Palermo', '56765', 'DDFP26742647G46')
INSERT INTO Anagrafica VALUES ('Saro', 'Giacomo', 'Viale della liberta', 'Palermo', '75020', 'LRRNCL91D04G657M')
INSERT INTO Anagrafica VALUES ('Urs', 'gioavnni', 'Via Salvemini ', 'Cosenza', '45665', 'GGG56736736B')


INSERT INTO TipoViolazione VALUES ('Eccesso di velovità')
INSERT INTO TipoViolazione VALUES ('Guida pericolosa')
INSERT INTO TipoViolazione VALUES ('Mancato pagamento delle imposte')
INSERT INTO TipoViolazione VALUES ('Guida in stato di ebbrezza')
INSERT INTO TipoViolazione VALUES ('Violazione di domcilio')
INSERT INTO TipoViolazione VALUES ('Spaccio di sostanze stupefacenti')
INSERT INTO TipoViolazione VALUES ('Atti osceni in luogo pubblico')


INSERT INTO Verbale VALUES ('20090107 09:00', 'Via del non ritorno 5', 'Agente Patogeno', '20221007 10:00', 180, 7, 1, 3)
INSERT INTO Verbale VALUES ('20090217 19:00', 'Via della pazzia 19', 'Agente 007', '20090217 20:00', 450, 7, 2, 1)
INSERT INTO Verbale VALUES ('20220322 23:00', 'Via salvatore caiati 10', 'Agente Watson', '20220323 01:00', 270, 11, 3, 2)
INSERT INTO Verbale VALUES ('20211007 21:20', 'Via imbroglione maedetto 11',  'Agente lark', '20211007 22:00', 1000, 9, 4, 7)
INSERT INTO Verbale VALUES ('20201117 16:24', 'Via della rinascita 22', 'Agente Gordon', '20201117 18:14', 2000, 18, 5, 6)
INSERT INTO Verbale VALUES ('20190714 13:18', 'Via della sobrieta 12', ' Agente Philadelphia', '20190714 15:15', 290, 2, 6, 4)
INSERT INTO Verbale VALUES ('20190219 12:00', 'viale della liberta 15', ' Agente Murphy',  '20190219 13:30', 790, 8, 7, 5)


--1. Conteggio dei verbali trascritti:

SELECT COUNT(*) AS VerbaliTrascritti FROM Verbale


--2. Conteggio dei verbali trascritti raggruppati per anagrafe:

SELECT Cognome, Nome, COUNT(IDVerbale) AS VerbaliTrascritti
		FROM Verbale JOIN Anagrafica 
		ON Verbale.IDAnagrafica = Anagrafica.IDAnagrafica
		GROUP BY Cognome, Nome


--3. Conteggio dei verbali trascritti raggruppati per tipo di violazione:

SELECT Descrizione, COUNT(IDVerbale) AS VerbaliTrascritti
		FROM Verbale JOIN TipoViolazione 
		ON Verbale.IDViolazione = TipoViolazione.IDViolazione 
		GROUP BY Descrizione

--4. Totale dei punti decurtati per ogni anagrafe:

SELECT Cognome, Nome, SUM(DecurtamentoPunti) AS TotalePuntiDecurtati 
		FROM Verbale JOIN Anagrafica 
		ON Verbale.IDAnagrafica = Anagrafica.IDAnagrafica 
		GROUP BY Cognome, Nome


--5. Cognome, Nome, Data violazione, Indirizzo violazione, importo e punti decurtati per tutti gli anagrafici
--residenti a Palermo:


SELECT Cognome, Nome, DataViolazione, IndirizzoViolazione, Importo, DecurtamentoPunti
		FROM Anagrafica JOIN Verbale 
		ON Anagrafica.IDAnagrafica = Verbale.IDVerbale 
		WHERE Citta = 'Palermo' 


--6. Cognome, Nome, Indirizzo, Data violazione, importo e punti decurtati per le violazioni fatte tra il febbraio
--2009 e luglio 2009:

SELECT Cognome, Nome, IndirizzoViolazione, Importo, DecurtamentoPunti
		FROM Anagrafica JOIN Verbale 
		ON Anagrafica.IDAnagrafica = Verbale.IDVerbale 
		WHERE DataViolazione BETWEEN '20090207' AND '20090701'


--7. Totale degli importi per ogni anagrafico:

SELECT Cognome, Nome, SUM(Importo) AS TotaleImporti 
		FROM Verbale JOIN Anagrafica
		ON Verbale.IDAnagrafica = Anagrafica.IDAnagrafica
		GROUP BY Cognome, Nome
		

--8. Visualizzazione di tutti gli anagrafici residenti a Palermo:

SELECT * FROM Anagrafica  
		 WHERE Citta = 'Palermo' 

--9. Query parametrica che visualizzi Data violazione, Importo e decurta mento punti relativi ad una certa data:



--10. Conteggio delle violazioni contestate raggruppate per Nominativo dell’agente di Polizia:

SELECT NominativoAgente, COUNT(IDViolazione) AS ViolazioniContestate
		FROM Verbale 
		GROUP BY NominativoAgente

--11. Cognome, Nome, Indirizzo, Data violazione, Importo e punti decurtati per tutte le violazioni che superino il
--decurtamento di 5 punti:

SELECT Cognome, Nome, IndirizzoViolazione, Importo, DecurtamentoPunti
		FROM Anagrafica JOIN Verbale 
		ON Anagrafica.IDAnagrafica = Verbale.IDAnagrafica		 
		WHERE DecurtamentoPunti > 5

--12. Cognome, Nome, Indirizzo, Data violazione, Importo e punti decurtati per tutte le violazioni che superino
--l’importo di 400 euro:

SELECT Cognome, Nome, IndirizzoViolazione, Importo, DecurtamentoPunti
		FROM Anagrafica JOIN Verbale 
		ON Anagrafica.IDAnagrafica = Verbale.IDAnagrafica		 
		WHERE Importo > 400
