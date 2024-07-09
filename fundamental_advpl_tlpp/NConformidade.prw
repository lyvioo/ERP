#Include "protheus.ch"

User Function RegistroNaoConformidade()
    Local oDlg
    Local oBtnSalvar, oBtnCancelar
    Local nCodigo := 0
    Local cTipoNC := Space(30)
    Local cDescNC := Space(50)
    Local nQtdeNC := 0
    Local aTipoNC := { ;
        "01 - Transportadora", ;
        "01.01 - Produto Avariado", ;
        "01.02 - Rótulos", ;
        "01.03 - Embalagens", ;
        "01.04 - Faturamento", ;
        "01.05 - Produção", ;
        "01.06 - Pedido Incorreto", ;
        "01.07 - Pedido em duplicado", ;
        "01.08 - Matéria prima", ;
        "01.09 - Liberação pedido de venda", ;
        "01.10 - Montagem", ;
        "01.11 - Logística", ;
        "01.12 - Erro do Cliente", ;
        "01.13 - Comercial", ;
        "01.14 - Representante", ;
        "01.15 - Formutação", ;
        "01.16 - Sistema" }

    DEFINE DIALOG oDlg TITLE "Registro de não conformidade" FROM 0, 0 TO 500, 700 PIXEL
        @ 10, 10 SAY "Código:" OF oDlg PIXEL
        @ 10, 120 GET nCodigo PICTURE "999999" OF oDlg PIXEL SIZE 150, 20

        @ 40, 10 SAY "Tipo de não conformidade:" OF oDlg PIXEL
        @ 40, 180 COMBOBOX cTipoNC ITEMS aTipoNC OF oDlg PIXEL SIZE 250, 20

        @ 70, 10 SAY "Descrição da não conformidade:" OF oDlg PIXEL
        @ 70, 180 GET cDescNC OF oDlg PIXEL SIZE 250, 20

        @ 100, 10 SAY "Quantidade não conforme:" OF oDlg PIXEL
        @ 100, 180 GET nQtdeNC PICTURE "999999" OF oDlg PIXEL SIZE 100, 20

        @ 200, 10 BUTTON oBtnSalvar PROMPT "Salvar" SIZE 60, 20 PIXEL ACTION SaveNaoConformidade(nCodigo, cTipoNC, cDescNC, nQtdeNC, oDlg)
        @ 200, 80 BUTTON oBtnCancelar PROMPT "Cancelar" SIZE 60, 20 PIXEL ACTION oDlg:End()
    ACTIVATE DIALOG oDlg CENTERED
Return

Static Function SaveNaoConformidade(nCodigo, cTipoNC, cDescNC, nQtdeNC, oDlg)
    // Declarando variáveis locais no início da função
    //Local cDataOC := ""
    //Local cHoraOC := ""

    // Verificando se todos os campos foram preenchidos
    If Empty(nCodigo) .or. Empty(cTipoNC) .or. Empty(cDescNC)
        MsgInfo("Todos os campos devem ser preenchidos!", "Erro")
    Else
        // Reclock de inserção 
        DbSelectArea("ZZ1")
        ZZ1->(DBSETORDER(1))
        If !ZZ1->(RecLock("ZZ1",.T.))
            ZZ1->Z1_FILIAL := xFilial("ZZ1")
            ZZ1->Z1_CODIGO := GETSXENUM("ZZ1","Z1_CODIGO")
            ZZ1->Z1_TIPO := cTipoNC
            // Coloque aqui os demais campos       
            ZZ1->(MSUNLOCK())
            MsgStop("Erro na execução da query: " + TcSqlError(), "Erro")
        Else
            MsgInfo("Registro salvo com sucesso!", "Informação")
            oDlg:End()
        EndIf
    EndIf
Return
