#include 'protheus.ch'
#include 'apwebex.ch'

User function SiconvUF() 
Local cHtml := ''

WEB EXTENDED INIT cHtml

U_DBSetup()

U_LogSite()

cHtml := H_SiconvUF()                

WEB EXTENDED END

Return cHtml


