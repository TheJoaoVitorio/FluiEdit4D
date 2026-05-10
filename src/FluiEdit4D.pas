unit FluiEdit4D;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Graphics,
  Vcl.ExtCtrls, Vcl.Forms, Winapi.Windows, Winapi.Messages, Winapi.GDIPOBJ, 
  Winapi.GDIPAPI, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, Vcl.Imaging.GIFImg;

type
  TFluiEditStyle = (fsNormal, fsLabelOnTop, fsOutline);

  TFluiInnerIconScaleMode = (smOriginal, smStretch, smProportional);
  TFluiInnerIconPosition = (ipLeft, ipRight);

  TFluiInnerIcon = class(TPersistent)
  private
    FOwner: TPersistent;
    FPicture: TPicture;
    FPosition: TFluiInnerIconPosition;
    FSpacing: Integer;
    FScaleMode: TFluiInnerIconScaleMode;
    FVisible: Boolean;
    procedure SetPicture(const Value: TPicture);
    procedure SetPosition(const Value: TFluiInnerIconPosition);
    procedure SetSpacing(const Value: Integer);
    procedure SetScaleMode(const Value: TFluiInnerIconScaleMode);
    procedure SetVisible(const Value: Boolean);
    procedure Changed;
    procedure PictureChanged(Sender: TObject);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TPersistent);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Picture: TPicture read FPicture write SetPicture;
    property Position: TFluiInnerIconPosition read FPosition write SetPosition default ipLeft;
    property Spacing: Integer read FSpacing write SetSpacing default 4;
    property ScaleMode: TFluiInnerIconScaleMode read FScaleMode write SetScaleMode default smProportional;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  TFluiEdit4D = class(TCustomControl)
  private
    FEdit: TEdit;
    FLabel: TLabel;
    FInnerIcon: TFluiInnerIcon;
    FRounding: Integer;
    FStyle: TFluiEditStyle;
    FBorderColor: TColor;
    FFocusedColor: TColor;
    FBackgroundColor: TColor;
    FFocused: Boolean;
    FLabelSpacing: Integer;
    FLabelFont: TFont;
    FOnChange: TNotifyEvent;
    FTextHint: string;
    FTextHintOpacity: Byte;
    FOldEditProc: TWndMethod;
    FHelperLabel: TLabel;
    FHelperTextFont: TFont;
    FEnabledHelperText: Boolean;

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
    procedure SetLabelFont(const Value: TFont);
    procedure SetReadOnly(const Value: Boolean);
    function GetReadOnly: Boolean;
    procedure SetMaxLength(const Value: Integer);
    function GetMaxLength: Integer;
    procedure SetTextHint(const Value: string);
    function GetTextHint: string;
    procedure SetTextHintOpacity(const Value: Byte);
    procedure SetInnerIcon(const Value: TFluiInnerIcon);
    procedure SetHelperText(const Value: string);
    function GetHelperText: string;
    procedure SetEnabledHelperText(const Value: Boolean);
    procedure SetHelperTextFont(const Value: TFont);

    procedure EditGotFocus(Sender: TObject);
    procedure EditLostFocus(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure EditWindowProc(var Message: TMessage);
    procedure LabelFontChange(Sender: TObject);
    procedure HelperLabelFontChange(Sender: TObject);
    procedure UpdateLayout;
    function GetGDIColor(AColor: TColor): TGPColor;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure SetEnabled(Value: Boolean); override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
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
    property TextHint: string read GetTextHint write SetTextHint;
    property InnerIcon: TFluiInnerIcon read FInnerIcon write SetInnerIcon;
    property PasswordChar: Char read GetPasswordChar write SetPasswordChar default #0;
    property LabelSpacing: Integer read FLabelSpacing write SetLabelSpacing default 4;
    property LabelCaption: string read GetLabelCaption write SetLabelCaption;
    property LabelFont: TFont read FLabelFont write SetLabelFont;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property MaxLength: Integer read GetMaxLength write SetMaxLength default 0;
    property TextHintOpacity: Byte read FTextHintOpacity write SetTextHintOpacity default 120;
    property HelperText: string read GetHelperText write SetHelperText;
    property EnabledHelperText: Boolean read FEnabledHelperText write SetEnabledHelperText default False;
    property HelperTextFont: TFont read FHelperTextFont write SetHelperTextFont;
    
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
    property TabStop default False;
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

{ TFluiInnerIcon }

constructor TFluiInnerIcon.Create(AOwner: TPersistent);
begin
  inherited Create;
  FOwner := AOwner;
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  FPosition := ipLeft;
  FSpacing := 4;
  FScaleMode := smProportional;
  FVisible := True;
end;

destructor TFluiInnerIcon.Destroy;
begin
  FPicture.Free;
  inherited Destroy;
end;

procedure TFluiInnerIcon.Assign(Source: TPersistent);
begin
  if Source is TFluiInnerIcon then
  begin
    FPicture.Assign(TFluiInnerIcon(Source).Picture);
    FPosition := TFluiInnerIcon(Source).Position;
    FSpacing := TFluiInnerIcon(Source).Spacing;
    FScaleMode := TFluiInnerIcon(Source).ScaleMode;
    FVisible := TFluiInnerIcon(Source).Visible;
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TFluiInnerIcon.Changed;
begin
  if (FOwner <> nil) and (FOwner is TFluiEdit4D) then
  begin
    TFluiEdit4D(FOwner).UpdateLayout;
    TFluiEdit4D(FOwner).Invalidate;
  end;
end;

function TFluiInnerIcon.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TFluiInnerIcon.PictureChanged(Sender: TObject);
begin
  Changed;
end;

procedure TFluiInnerIcon.SetPicture(const Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TFluiInnerIcon.SetPosition(const Value: TFluiInnerIconPosition);
begin
  if FPosition <> Value then
  begin
    FPosition := Value;
    Changed;
  end;
end;

procedure TFluiInnerIcon.SetScaleMode(const Value: TFluiInnerIconScaleMode);
begin
  if FScaleMode <> Value then
  begin
    FScaleMode := Value;
    Changed;
  end;
end;

procedure TFluiInnerIcon.SetSpacing(const Value: Integer);
begin
  if FSpacing <> Value then
  begin
    FSpacing := Value;
    Changed;
  end;
end;

procedure TFluiInnerIcon.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed;
  end;
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
  TabStop := True;
  Cursor := crIBeam;
  FTextHintOpacity := 120;

  FLabelFont := TFont.Create;
  FLabelFont.OnChange := LabelFontChange;

  FInnerIcon := TFluiInnerIcon.Create(Self);

  FEdit := TEdit.Create(Self);
  FEdit.Parent := Self;
  FEdit.ParentFont := False;
  FEdit.BorderStyle := bsNone;
  FEdit.OnEnter := EditGotFocus;
  FEdit.OnExit := EditLostFocus;
  FEdit.OnChange := EditChange;
  FEdit.Color := FBackgroundColor;
  FEdit.TabStop := True;
  FEdit.Cursor := crIBeam;
  
  FOldEditProc := FEdit.WindowProc;
  FEdit.WindowProc := EditWindowProc;

  FLabel := TLabel.Create(Self);
  FLabel.Parent := Self;
  FLabel.ParentFont := False;
  FLabel.Caption := 'Label';
  FLabel.Visible := False;
  FLabel.Transparent := True;
  FLabel.Font.Size := 10;
  FLabel.Font.Assign(FLabelFont);

  FHelperTextFont := TFont.Create;
  FHelperTextFont.OnChange := HelperLabelFontChange;
  FHelperTextFont.Size := 8;
  FHelperTextFont.Color := clGray;

  FHelperLabel := TLabel.Create(Self);
  FHelperLabel.Parent := Self;
  FHelperLabel.ParentFont := False;
  FHelperLabel.Caption := '';
  FHelperLabel.Visible := False;
  FHelperLabel.Transparent := True;
  FHelperLabel.Font.Assign(FHelperTextFont);

  UpdateLayout;
end;

destructor TFluiEdit4D.Destroy;
begin
  FHelperTextFont.Free;
  FLabelFont.Free;
  FInnerIcon.Free;
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

function TFluiEdit4D.GetHelperText: string;
begin
  Result := FHelperLabel.Caption;
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

procedure TFluiEdit4D.HelperLabelFontChange(Sender: TObject);
begin
  FHelperLabel.Font.Assign(FHelperTextFont);
  UpdateLayout;
  Invalidate;
end;

procedure TFluiEdit4D.LabelFontChange(Sender: TObject);
begin
  FLabel.Font.Assign(FLabelFont);
  UpdateLayout;
  Invalidate;
end;

procedure TFluiEdit4D.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if FEdit.CanFocus then
    FEdit.SetFocus;
end;

procedure TFluiEdit4D.WMSetFocus(var Message: TWMSetFocus);
begin
  FEdit.SetFocus;
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
  LIconRect: TRect;
  LIconWidth, LIconHeight: Integer;
  LTop: Integer;
  LScale: Single;
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

    // Adjust bottom if HelperText is enabled
    if FEnabledHelperText then
      LRect.Bottom := LRect.Bottom - FHelperLabel.Height - 4;

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

  // Draw Icon using VCL StretchDraw
  if FInnerIcon.Visible and (FInnerIcon.Picture.Graphic <> nil) and not FInnerIcon.Picture.Graphic.Empty then
  begin
    LTop := 0;
    if FStyle = fsLabelOnTop then
      LTop := FLabel.Height + FLabelSpacing
    else if FStyle = fsOutline then
      LTop := FLabel.Height div 2;

    LIconHeight := (LRect.Bottom - LRect.Top) - 12;
    LIconWidth := LIconHeight;

    case FInnerIcon.ScaleMode of
      smOriginal:
      begin
        LIconWidth := FInnerIcon.Picture.Width;
        LIconHeight := FInnerIcon.Picture.Height;
      end;
      smStretch: ; // Default LIconWidth/LIconHeight
      smProportional:
      begin
        if FInnerIcon.Picture.Height > 0 then
          LScale := LIconHeight / FInnerIcon.Picture.Height
        else
          LScale := 1;
        LIconWidth := Round(FInnerIcon.Picture.Width * LScale);
      end;
    end;

    if FInnerIcon.Position = ipLeft then
      LIconRect.Left := (FRounding div 2) + 8
    else
      LIconRect.Left := Self.Width - (FRounding div 2) - 8 - LIconWidth;

    LIconRect.Top := LRect.Top + (LRect.Bottom - LRect.Top - LIconHeight) div 2;
    LIconRect.Right := LIconRect.Left + LIconWidth;
    LIconRect.Bottom := LIconRect.Top + LIconHeight;

    Canvas.StretchDraw(LIconRect, FInnerIcon.Picture.Graphic);
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
  FHelperLabel.Enabled := Value;
  Invalidate;
end;

procedure TFluiEdit4D.SetEnabledHelperText(const Value: Boolean);
begin
  if FEnabledHelperText <> Value then
  begin
    FEnabledHelperText := Value;
    FHelperLabel.Visible := Value;
    UpdateLayout;
    Invalidate;
  end;
end;

procedure TFluiEdit4D.SetFocusedColor(const Value: TColor);
begin
  FFocusedColor := Value;
  Invalidate;
end;

procedure TFluiEdit4D.SetHelperText(const Value: string);
begin
  FHelperLabel.Caption := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TFluiEdit4D.SetHelperTextFont(const Value: TFont);
begin
  FHelperTextFont.Assign(Value);
end;

procedure TFluiEdit4D.SetInnerIcon(const Value: TFluiInnerIcon);
begin
  FInnerIcon.Assign(Value);
end;

procedure TFluiEdit4D.SetLabelCaption(const Value: string);
begin
  FLabel.Caption := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TFluiEdit4D.SetLabelFont(const Value: TFont);
begin
  FLabelFont.Assign(Value);
end;

procedure TFluiEdit4D.SetLabelSpacing(const Value: Integer);
begin
  FLabelSpacing := Value;
  UpdateLayout;
  Invalidate;
end;

procedure TFluiEdit4D.SetTextHintOpacity(const Value: Byte);
begin
  if FTextHintOpacity <> Value then
  begin
    FTextHintOpacity := Value;
    FEdit.Invalidate;
  end;
end;

procedure TFluiEdit4D.SetTextHint(const Value: string);
begin
  if FTextHint <> Value then
  begin
    FTextHint := Value;
    // We don't set FEdit.TextHint to avoid native rendering
    FEdit.Invalidate;
  end;
end;

function TFluiEdit4D.GetTextHint: string;
begin
  Result := FTextHint;
end;

procedure TFluiEdit4D.EditWindowProc(var Message: TMessage);
var
  LDC: HDC;
  LGraphics: TGPGraphics;
  LBrush: TGPSolidBrush;
  LFont: TGPFont;
  LFamily: TGPFontFamily;
  LColor: TColor;
begin
  FOldEditProc(Message);

  if (Message.Msg = WM_PAINT) and (FEdit.Text = '') and (FTextHint <> '') then
  begin
    LDC := GetDC(FEdit.Handle);
    try
      LGraphics := TGPGraphics.Create(LDC);
      try
        LGraphics.SetTextRenderingHint(TextRenderingHintAntiAlias);
        LFamily := TGPFontFamily.Create(FEdit.Font.Name);
        try
          LFont := TGPFont.Create(LFamily, Single(FEdit.Font.Size), FontStyleRegular, UnitPoint);
          try
            LColor := ColorToRGB(FEdit.Font.Color);
            LBrush := TGPSolidBrush.Create(MakeColor(FTextHintOpacity, GetRValue(LColor), GetGValue(LColor), GetBValue(LColor)));
            try
              LGraphics.DrawString(FTextHint, -1, LFont, MakePoint(0.0, 0.0), LBrush);
            finally
              LBrush.Free;
            end;
          finally
            LFont.Free;
          end;
        finally
          LFamily.Free;
        end;
      finally
        LGraphics.Free;
      end;
    finally
      ReleaseDC(FEdit.Handle, LDC);
    end;
  end;
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
  LIconSpace: Integer;
  LIconWidth: Integer;
  LScale: Single;
  LAvailableHeight: Integer;
begin
  if not Assigned(FEdit) or not Assigned(FLabel) or not Assigned(FInnerIcon) or not Assigned(FHelperLabel) then Exit;

  FLabel.Visible := FStyle in [fsLabelOnTop, fsOutline];
  
  if FLabel.Visible then
  begin
    FLabel.Parent := Self;
    FLabel.Left := 4;
    FLabel.Top := 0;
    if FStyle = fsLabelOnTop then
      LTop := FLabel.Height + FLabelSpacing
    else
      LTop := FLabel.Height div 2;
  end
  else
  begin
    FLabel.Parent := nil;
    LTop := 0;
  end;

  FHelperLabel.Visible := FEnabledHelperText;
  if FHelperLabel.Visible then
  begin
    FHelperLabel.Left := 4;
    FHelperLabel.Top := Self.Height - FHelperLabel.Height;
    LAvailableHeight := Self.Height - LTop - FHelperLabel.Height - 4;
  end
  else
    LAvailableHeight := Self.Height - LTop;

  LIconSpace := 0;
  if FInnerIcon.Visible and (FInnerIcon.Picture.Graphic <> nil) and not FInnerIcon.Picture.Graphic.Empty then
  begin
    case FInnerIcon.ScaleMode of
      smOriginal: LIconWidth := FInnerIcon.Picture.Width;
      smStretch: LIconWidth := LAvailableHeight - 12;
      smProportional:
      begin
        if FInnerIcon.Picture.Height > 0 then
          LScale := (LAvailableHeight - 12) / FInnerIcon.Picture.Height
        else
          LScale := 1;
        LIconWidth := Round(FInnerIcon.Picture.Width * LScale);
      end;
    else
      LIconWidth := 0;
    end;
    LIconSpace := LIconWidth + FInnerIcon.Spacing;
  end;

  if FInnerIcon.Position = ipLeft then
    FEdit.Left := (FRounding div 2) + 8 + LIconSpace
  else
    FEdit.Left := (FRounding div 2) + 8;

  // Perfect vertical alignment using the calculated available height
  FEdit.Top := LTop + (LAvailableHeight - FEdit.Height) div 2;
  FEdit.Width := Self.Width - (FRounding + 16) - LIconSpace;
  
  // Height adjustment for fsLabelOnTop and HelperText
  if (FStyle in [fsLabelOnTop, fsOutline, fsNormal]) then
  begin
    LIconWidth := 30; // base height requirement
    if FStyle = fsLabelOnTop then LIconWidth := FLabel.Height + FLabelSpacing + 30;
    if FEnabledHelperText then LIconWidth := LIconWidth + FHelperLabel.Height + 4;
    
    if Height < LIconWidth then
      Height := LIconWidth;
  end;
end;

procedure TFluiEdit4D.Loaded;
begin
  inherited;
  UpdateLayout;
end;


procedure TFluiEdit4D.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  FEdit.Enabled := Enabled;
  FLabel.Enabled := Enabled;
  FHelperLabel.Enabled := Enabled;
end;

procedure TFluiEdit4D.CMFontChanged(var Message: TMessage);
begin
  inherited;
  FEdit.Font.Assign(Font);
  UpdateLayout;
end;

end.
