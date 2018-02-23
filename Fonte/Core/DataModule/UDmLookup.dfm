object DmLookup: TDmLookup
  OldCreateOrder = False
  Height = 317
  Width = 351
  object FDQryGarcom: TFDQuery
    Connection = DmBD.DBConexao
    SQL.Strings = (
      'SELECT * FROM GARCONS')
    Left = 40
    Top = 24
  end
  object FDQryMesa: TFDQuery
    Connection = DmBD.DBConexao
    SQL.Strings = (
      'SELECT * FROM MESAS')
    Left = 40
    Top = 96
  end
  object DsGarcom: TDataSource
    DataSet = FDQryGarcom
    Left = 120
    Top = 24
  end
  object DsMesa: TDataSource
    DataSet = FDQryMesa
    Left = 120
    Top = 96
  end
end
