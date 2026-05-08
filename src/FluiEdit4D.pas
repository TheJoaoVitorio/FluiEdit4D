unit FluiEdit4D;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Graphics,
  Vcl.ExtCtrls, Vcl.Forms, Winapi.Windows, Winapi.Messages, Winapi.GDIPOBJ, Winapi.GDIPAPI;

type
  TFluiEditStyle = (fsNormal, fsLabelOnTop, fsOutline);

  TFluiEdit4D = class(TCustomControl)
  private
    FEdit: TEdit;
    FLabel: TLabel;
    FRounding: Integer;
    FStyle: TFluiEditStyle;
    FBorderColor: TColor;
    FFocusedColor: TColor;
    FBackgroundColor: TColor;
    FFocused: Boolean;
    FLabelSpacing: Integer;
    FOnChange: TNotifyEvent;

    procedure SetRounding(const Value: Integer);
    procedure SetStyle(const Value: TFluiEditStyle);
    procedure SetBorderColor(const Value: TColor);
    procedure SetFocusedColor(const Value: TColor);
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetText(const Value: string);
    function GetText: string;
    procedure SetPasswordChar(const Value: Char);
    function GetPasswordChar: Char;
    procedure SetLabelSpacing(const Value: Integer);
    procedure SetLabelCaption(const Value: string);
    function GetLabelCaption: string;
    procedure SetReadOnly(const Value: Boolean);
    function GetReadOnly: Boolean;
    procedure SetMaxLength(const Value: Integer);
    function GetMaxLength: Integer;

    procedure EditGotFocus(Sender: TObject);
    procedure EditLostFocus(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure UpdateLayout;
    function GetGDIColor(AColor: TColor): TGPColor;
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure SetEnabled(Value: Boolean); override;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Edit: TEdit read FEdit;
    property EditLabel: TLabel read FLabel;
  published
    property Rounding: Integer read FRounding write SetRounding default 8;
    property Style: TFluiEditStyle read FStyle write SetStyle default fsNormal;
    property BorderColor: TColor read FBorderColor write SetBorderColor default $00D8D8D8;
    property FocusedColor: TColor read FFocusedColor write SetFocusedColor default $00FF8000;
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor default clWhite;
    property Text: string read GetText write SetText;
    property PasswordChar: Char read GetPasswordChar write SetPasswordChar default #0;
    property LabelSpacing: Integer read FLabelSpacing write SetLabelSpacing default 4;
    property LabelCaption: string read GetLabelCaption write SetLabelCaption;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property MaxLength: Integer read GetMaxLength write SetMaxLength default 0;
    
    property Align;
    property Anchors;
    property Color;
    property Constraints;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('FLUI', [TFluiEdit4D]);
end;

{ TFluiEdit4D }

constructor TFluiEdit4D.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 200;
  Height := 40;
  FRounding := 8;
  FStyle := fsNormal;
  FBorderColor := $00D8D8D8;
  FFocusedColor := $00FF8000;
  FBackgroundColor := clWhite;
  FLabelSpacing := 4;
  FFocused := False;

  FEdit := TEdit.Create(Self);
  FEdit.Parent := Self;
  FEdit.BorderStyle := bsNone;
  FEdit.OnEnter := EditGotFocus;
  FEdit.OnExit := EditLostFocus;
  FEdit.OnChange := EditChange;
  FEdit.Color := FBackgroundColor;

  FLabel := TLabel.Create(Self);
  FLabel.Parent := Self;
  FLabel.Caption := 'Label';
  FLabel.Visible := False;
  FLabel.Transparent := True;

  UpdateLayout;
end;

destructor TFluiEdit4D.Destroy;
begin
  inherited Destroy;
end;

procedure TFluiEdit4D.EditChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TFluiEdit4D.EditGotFocus(Sender: TObject);
begin
  FFocused := True;
  Invalidate;
  if Assigned(OnEnter) then OnEnter(Self);
end;

procedure TFluiEdit4D.EditLostFocus(Sender: TObject);
begin
  FFocused := False;
  Invalidate;
  if Assigned(OnExit) then OnExit(Self);
end;

function TFluiEdit4D.GetGDIColor(AColor: TColor): TGPColor;
var
  LColor: TColor;
begin
  LColor := ColorToRGB(AColor);
  Result := MakeColor(255, GetRValue(LColor), GetGValue(LColor), GetBValue(LColor));
end;

function TFluiEdit4D.GetLabelCaption: string;
begin
  Result := FLabel.Caption;
end;

function TFluiEdit4D.GetMaxLength: Integer;
begin
  Result := FEdit.MaxLength;
end;

function TFluiEdit4D.GetPasswordChar: Char;
begin
  Result := FEdit.PasswordChar;
end;

function TFluiEdit4D.GetReadOnly: Boolean;
begin
  Result := FEdit.ReadOnly;
end;

function TFluiEdit4D.GetText: string;
begin
  Result := FEdit.Text;
end;

procedure TFluiEdit4D.Paint;
var
  LGraphics: TGPGraphics;
  LPath: TGPGraphicsPath;
  LBrush: TGPSolidBrush;
  LPen: TGPPen;
  LRound: Single;
  LRect: TRect;
  LColor: TGPColor;
  LBorderWidth: Single;
begin
  inherited;
  LGraphics := TGPGraphics.Create(Canvas.Handle);
  try
    LGraphics.SetSmoothingMode(SmoothingModeAntiAlias);

    LRect := ClientRect;
    
    // Adjust rect based on style
    if FStyle = fsLabelOnTop then
    begin
      LRect.Top := FLabel.Height + FLabelSpacing;
    end
    else if FStyle = fsOutline then
    begin
      LRect.Top := FLabel.Height div 2;
    end;

    LRound := FRounding;
    if LRound > (LRect.Bottom - LRect.Top) then LRound := (LRect.Bottom - LRect.Top);
    if LRound > (LRect.Right - LRect.Left) then LRound := (LRect.Right - LRect.Left);

    LPath := TGPGraphicsPath.Create;
    try
      LBorderWidth := 1.5;
      LPath.AddArc(LRect.Left + LBorderWidth, LRect.Top + LBorderWidth, LRound, LRound, 180, 90);
      LPath.AddArc(LRect.Right - LRound - LBorderWidth, LRect.Top + LBorderWidth, LRound, LRound, 270, 90);
      LPath.AddArc(LRect.Right - LRound - LBorderWidth, LRect.Bottom - LRound - LBorderWidth, LRound, LRound, 0, 90);
      LPath.AddArc(LRect.Left + LBorderWidth, LRect.Bottom - LRound - LBorderWidth, LRound, LRound, 90, 90);
      LPath.CloseFigure;

      // Fill Background
      LBrush := TGPSolidBrush.Create(GetGDIColor(FBackgroundColor));
      try
        LGraphics.FillPath(LBrush, LPath);
      finally
        LBrush.Free;
      end;

      // Draw Border
      if FFocused then
        LColor := GetGDIColor(FFocusedColor)
      else
        LColor := GetGDIColor(FBorderColor);

      LPen := TGPPen.Create(LColor, LBorderWidth);
      try
        LGraphics.DrawPath(LPen, LPath);
        
        // If Outline, clear the border under the label
        if FStyle = fsOutline then
        begin
          LBrush := TGPSolidBrush.Create(GetGDIColor(Self.Color));
          try
            LGraphics.FillRectangle(LBrush, FLabel.Left + 2, LRect.Top - 2, FLabel.Width + 4, 4);
          finally
            LBrush.Free;
          end;
        end;
      finally
        LPen.Free;
      end;
    finally
      LPath.Free;
    end;
  finally
    LGraphics.Free;
  end;
end;

procedure TFluiEdit4D.Resize;
begin
  inherited;
  UpdateLayout;
end;

procedure TFluiEdit4D.SetBackgroundColor(const Value: TColor);
begin
  FBackgroundColor := Value;
  FEdit.Color := Value;
  Invalidate;
end;

procedure TFluiEdit4D.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  Invalidate;
end;

procedure TFluiEdit4D.SetEnabled(Value: Boolean);
begin
  inherited;
  FEdit.Enabled := Value;
  FLabel.Enabled := Value;
  Invalidate;
end;

procedure TFluiEdit4D.SetFocusedColor(const Value: TColor);
begin
  FFocusedColor := Value;
  Invalidate;
end;

procedure TFluiEdit4D.SetLabelCaption(const Value: string);
begin
  FLabel.Caption := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TFluiEdit4D.SetLabelSpacing(const Value: Integer);
begin
  FLabelSpacing := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TFluiEdit4D.SetMaxLength(const Value: Integer);
begin
  FEdit.MaxLength := Value;
end;

procedure TFluiEdit4D.SetPasswordChar(const Value: Char);
begin
  FEdit.PasswordChar := Value;
end;

procedure TFluiEdit4D.SetReadOnly(const Value: Boolean);
begin
  FEdit.ReadOnly := Value;
end;

procedure TFluiEdit4D.SetRounding(const Value: Integer);
begin
  FRounding := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TFluiEdit4D.SetStyle(const Value: TFluiEditStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    UpdateLayout;
    Invalidate;
  end;
end;

procedure TFluiEdit4D.SetText(const Value: string);
begin
  FEdit.Text := Value;
end;

procedure TFluiEdit4D.UpdateLayout;
var
  LTop: Integer;
begin
  if not Assigned(FEdit) then Exit;

  FLabel.Visible := FStyle in [fsLabelOnTop, fsOutline];
  
  if FLabel.Visible then
  begin
    FLabel.Left := 4;
    FLabel.Top := 0;
    LTop := FLabel.Height + FLabelSpacing;
  end
  else
  begin
    LTop := 0;
  end;

  FEdit.Left := (FRounding div 2) + 8;
  FEdit.Top := LTop + (Self.Height - LTop - FEdit.Height) div 2;
  FEdit.Width := Self.Width - (FRounding + 16);
  
  // Height adjustment for fsLabelOnTop
  if (FStyle in [fsLabelOnTop, fsOutline]) and (Height < FLabel.Height + 25) then
    Height := FLabel.Height + FLabelSpacing + 30;
end;


procedure TFluiEdit4D.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  FEdit.Enabled := Enabled;
  FLabel.Enabled := Enabled;
end;

procedure TFluiEdit4D.CMFontChanged(var Message: TMessage);
begin
  inherited;
  FEdit.Font.Assign(Font);
  UpdateLayout;
end;

end.
