unit UFrmPayments;

interface

uses
    Aurelius.Bind.BaseDataset
  , Aurelius.Bind.Dataset
  , Aurelius.Criteria.Base
  , Aurelius.Criteria.Linq
  , Aurelius.Criteria.Projections
  , Aurelius.Engine.ObjectManager
  , Aurelius.Types.Blob
  , Aurelius.Types.Proxy

  , Data.DB

  , System.Classes
  , System.SysUtils
  , System.Variants

  , Vcl.Controls
  , Vcl.DBGrids
  , Vcl.Dialogs
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.Grids

  , Winapi.Messages
  , Winapi.Windows

  , UFrmBase, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ExtCtrls
  ;


type
  TFrmPayments = class(TFrmBase)
    Payments: TAureliusDataset;
    GridPayments: TDBGrid;
    PaymentsId: TIntegerField;
    PaymentsInvoice: TAureliusEntityField;
    PaymentsPaidOn: TDateField;
    PaymentsAmount: TFloatField;
    sourcePayments: TDataSource;
    DBNavigator1: TDBNavigator;
    PaymentsInvoiceNumber: TIntegerField;
    Invoice: TAureliusDataset;
    sourceInvoice: TDataSource;
    btnPayOff: TButton;
    txtDue: TLabel;
    procedure btnPayOffClick(Sender: TObject);
    procedure sourcePaymentsDataChange(Sender: TObject; Field: TField);
    procedure sourcePaymentsStateChange(Sender: TObject);
  private
    { Private declarations }
    FDataSet: TAureliusDataset;
    FDataSource: TDataSource;

    FAmountDue: Double;

    procedure UpdateAmountDue;
  public
    { Public declarations }
    constructor Create(
      AObjManager: TObjectManager;
      ADataSource: TDataSource
      ); reintroduce;

  end;


implementation

uses
  System.DateUtils
  , UInvoice
  ;

{$R *.dfm}

{ TFrmPayments }

constructor TFrmPayments.Create(AObjManager: TObjectManager;
  ADataSource: TDataSource);
begin
  inherited Create( nil );

  FDataset := ADataSource.DataSet as TAureliusDataset;
  FDataSource := ADataSource;

  Payments.Close;
  Payments.DatasetField := FDataSet.FieldByName('Payments') as TDatasetField;
  Payments.Open;


  Caption := Format(
    'Invoice %d - Payments', [ FDataSet.FieldByName('Number').AsInteger ]
    );

  UpdateAmountDue;
end;

procedure TFrmPayments.btnPayOffClick(Sender: TObject);
begin
  Payments.Append;
  PaymentsPaidOn.AsDateTime := TDateTime.Today;
  PaymentsAmount.AsFloat := FAmountDue;
  Payments.Post;
end;

procedure TFrmPayments.sourcePaymentsDataChange(Sender: TObject; Field: TField);
begin
  UpdateAmountDue;
end;

procedure TFrmPayments.sourcePaymentsStateChange(Sender: TObject);
begin
 UpdateAmountDue;
end;

procedure TFrmPayments.UpdateAmountDue;
var
  LBookmark: TBookmark;
  LSum: Double;
begin
  if Payments.State = dsBrowse then
  begin
    LSum := 0;
    Payments.DisableControls;
    LBookmark := Payments.GetBookmark;
    try
      Payments.First;
      while Payments.Eof = False do
      begin
        LSum := LSum + PaymentsAmount.AsFloat;
        Payments.Next;
      end;

      var LDue := FDataset.FieldByName('TotalAmount').AsFloat - LSum;
      if LDue > 0 then
      begin
        txtDue.Font.Color := clRed;
      end
      else
      begin
        txtDue.Font.Color := clGreen;
      end;
      FAmountDue := LDue;
      txtDue.Caption := Format( '%m', [FAmountDue]);

      Payments.GotoBookmark(LBookmark);
    finally
      Payments.EnableControls;
      Payments.FreeBookmark(LBookmark);
    end;
  end;
end;

end.