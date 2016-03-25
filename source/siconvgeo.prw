#include 'protheus.ch'
#include 'apwebex.ch'

User Function siconvgeo()

Local cHtml := ''
Local cQuery
Local nLat
Local nLong

WEB EXTENDED INIT cHtml

PRIVATE cLat := HTTPGET->LAT
PRIVATE cLong := HTTPGET->LONG
PRIVATE aMunic := {}

nLat := round(val(cLat),2)
nLong := round(val(cLong),2)

U_DBSetup()

U_LogSite()

If empty(cLat) .or. empty(cLong)
	
	PRIVATE cErrorMSG := "Coordenadas geogr�ficas n�o recebidas."
	PRIVATE cErrorHLP := 'A busca por sua localiza��o atual n�o recebeu corretamente as informa��es de localiza��o. '+;
				'Certifique-se de aceitar o uso de sua localia��o para utilizar esta op��o. '+;
				'Retorne para a tela anterior e tente novamente, ou volte ao in�cio do site.'
	
	cHtml := h_SicError()
	
Else
	
	cQuery := "select MUN.CODIGO,GEO.MUNICIPIO,GEO.UF,"
	cQuery += " abs ( round(LATITUDE,2) - (-23.60) )  + abs ( round(LONGITUDE,2) - (-46.74) ) as DIF "
	cQuery += " from convenioaux.dbo.MunicipiosBrasil1 GEO , "
	cQuery += " convenioaux.dbo.MUNICIP MUN "
	cQuery += " where abs ( round(GEO.LATITUDE,2) - ("+cValToChar(nLat)+") )  "
	cQuery += " + abs ( round(GEO.LONGITUDE,2) - ("+cValToChar(nLong)+") ) < 0.2 "
	cQuery += " and  GEO.MUNICIPIO = MUN.NOME "
	cQuery += " and  GEO.UF = MUN.UF "
	cQuery += " order by 4"
	
	USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA "TOPCONN"
	
	While !eof()
		aadd(aMunic,{QRY->CODIGO,alltrim(QRY->MUNICIPIO),alltrim(QRY->UF)})
		DbSkip()
	Enddo
	
	USE
	
	cHtml := H_SiconvGeo()
	
Endif

WEB EXTENDED END

Return cHtml


