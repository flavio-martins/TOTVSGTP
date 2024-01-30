#INCLUDE "rwmake.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TOTVS.ch"

/*/{Protheus.doc} GTPR310
Rel. Lista de passageiros
@type function
@author Flávio Martins
@since 26/01/2024
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Function GTPR901()
	
   Local cPerg := "GTPR901"

   MV_PAR01 := GQ8->GQ8_CODIGO
   MV_PAR02 := GQ8->GQ8_CODIGO

   Pergunte( cPerg )
	oReport		:= ReportDef()
	oReport:PrintDialog()
			
Return()

/*/{Protheus.doc} ReportDef
Função responsavel para definição do layout do relatório
@type function
@author Flávio Martins
@since 26/01/2024
@version 1.0
@param cAliasTmp, character, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function ReportDef()
	
	Local oReport
	Local oSecViagem
	Local oSecPassageiros
	Local cTitulo 	:= '[GTPR901] - '+ "Lista de Passageiros"
	Local cAliasTmp	:= QryLista()
	
	SX3->(DBSETORDER(1))
	 
	oReport := TReport():New('GTPR901', cTitulo, , {|oReport| PrintReport(oReport,cAliasTmp)}, 'Este relatório ira imprimir a lista de passageiros' ,,,.T.  ) 
					
	oSecViagem := TRSection():New( oReport, "Viagem" ,{cAliasTmp} )

	TRCell():New(oSecViagem , "GQ8_CODIGO"	, cAliasTmp , X3TITULO("GQ8_CODIGO")	, X3PICTURE("GQ8_CODIGO") , TamSX3("GQ8_CODIGO")[1]+2)
	TRCell():New(oSecViagem , "GQ8_DESCRI"	, cAliasTmp , X3TITULO("GQ8_DESCRI")	, X3PICTURE("GQ8_DESCRI") , TamSX3("GQ8_DESCRI")[1]+2)

	oSecPassageiros 	:= TRSection():New(oReport, "Passageiros"	, 	{cAliasTmp}  , , .F., .T.)
	oSecPassageiros:SetLeftMargin(05) 

   TRCell():New(oSecPassageiros	, "GQB_ITEM"	, cAliasTmp , X3TITULO("GQB_ITEM")   , X3PICTURE("GQB_ITEM")   , TamSX3("GQB_ITEM")[1]+2)
   TRCell():New(oSecPassageiros	, "GQB_NOME"	, cAliasTmp , X3TITULO("GQB_NOME")   , X3PICTURE("GQB_NOME")   , TamSX3("GQB_NOME")[1]+2)
   TRCell():New(oSecPassageiros	, "GQB_CPF"	   , cAliasTmp , X3TITULO("GQB_CPF")    , X3PICTURE("GQB_CPF")    , TamSX3("GQB_CPF")[1]+2) 
   TRCell():New(oSecPassageiros	, "GQB_CEP"	   , cAliasTmp , X3TITULO("GQB_CEP")    , X3PICTURE("GQB_CEP")    , TamSX3("GQB_CEP")[1]+2)
   TRCell():New(oSecPassageiros	, "GQB_ENDERE"	, cAliasTmp , X3TITULO("GQB_ENDERE") , X3PICTURE("GQB_ENDERE") , TamSX3("GQB_ENDERE")[1]+2)
   TRCell():New(oSecPassageiros	, "GQB_COMPLE"	, cAliasTmp , X3TITULO("GQB_COMPLE") , X3PICTURE("GQB_COMPLE") , TamSX3("GQB_COMPLE")[1]+2)
   TRCell():New(oSecPassageiros	, "GQB_BAIRRO"	, cAliasTmp , X3TITULO("GQB_BAIRRO") , X3PICTURE("GQB_BAIRRO") , TamSX3("GQB_BAIRRO")[1]+2)
   TRCell():New(oSecPassageiros	, "GQB_MUNICI"	, cAliasTmp , X3TITULO("GQB_MUNICI") , X3PICTURE("GQB_MUNICI") , TamSX3("GQB_MUNICI")[1]+2)
   TRCell():New(oSecPassageiros	, "GQB_ESTADO"	, cAliasTmp , X3TITULO("GQB_ESTADO") , X3PICTURE("GQB_ESTADO") , TamSX3("GQB_ESTADO")[1]+2)
	
Return (oReport)

/*/{Protheus.doc} PrintReport
(long_description)
@type function
@author Flávio Martins
@since 26/01/2024
@version 1.0
@param oReport, objeto, (objeto de relatorio)
@param cAliasTmp, character, (alias de coleção de dados)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function PrintReport( oReport,cAliasTmp )
 
	Local oSecViagem 	:= oReport:Section(1)
	Local oSecPassageiros	:= oReport:Section(2)
	Local cCodigo := ""
	
	DbSelectArea(cAliasTmp)
	oReport:SetMeter((cAliasTmp)->(ScopeCount()))
	oReport:SetLineHeight(30)
	oReport:lUnderLine := .F.
	
	(cAliasTmp)->(dbGoTop())
	While (cAliasTmp)->(!Eof())
		
		If (cAliasTmp)->GQB_CODIGO <> cCodigo	
			cCodigo := (cAliasTmp)->GQB_CODIGO			
			oSecViagem:Init()
			oSecViagem:Cell("GQ8_CODIGO"	):SetValue((cAliasTmp)->GQ8_CODIGO	)
			oSecViagem:Cell("GQ8_DESCRI"	):SetValue((cAliasTmp)->GQ8_DESCRI	)	
			oSecViagem:PrintLine()
			oSecViagem:Finish()				
			oSecPassageiros:Init()			
		Endif 

		oSecPassageiros:Cell("GQB_ITEM"   ):SetValue((cAliasTmp)->GQB_ITEM  )
		oSecPassageiros:Cell("GQB_NOME"   ):SetValue((cAliasTmp)->GQB_NOME  )
		oSecPassageiros:Cell("GQB_CPF"    ):SetValue((cAliasTmp)->GQB_CPF   )
		oSecPassageiros:Cell("GQB_CEP"    ):SetValue((cAliasTmp)->GQB_CEP   )
		oSecPassageiros:Cell("GQB_ENDERE" ):SetValue((cAliasTmp)->GQB_ENDERE)
		oSecPassageiros:Cell("GQB_COMPLE" ):SetValue((cAliasTmp)->GQB_COMPLE)		
		oSecPassageiros:Cell("GQB_BAIRRO" ):SetValue((cAliasTmp)->GQB_BAIRRO)
		oSecPassageiros:Cell("GQB_MUNICI" ):SetValue((cAliasTmp)->GQB_MUNICI)
		oSecPassageiros:Cell("GQB_ESTADO" ):SetValue((cAliasTmp)->GQB_ESTADO)
		
		oSecPassageiros:PrintLine()
		
		(cAliasTmp)->(dbSkip())
      If (cAliasTmp)->GQB_CODIGO <> cCodigo
	      oSecPassageiros:Finish()
      EndIf
   EndDo
	oReport:EndPage()
	
Return

/*/{Protheus.doc} QryLista
(long_description)
@type function
@author Flávio Martins
@since 26/01/2024
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function QryLista()
Local cAliasTmp	:= GetNextAlias()

BeginSql Alias cAliasTmp

   SELECT  * FROM %Table:GQ8% A
   INNER JOIN %Table:GQB% B ON B.GQB_CODIGO = A.GQ8_CODIGO
   WHERE A.%NotDel%
   AND B.%NotDel%
   AND A.GQ8_CODIGO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%

EndSql
  
Return cAliasTmp
