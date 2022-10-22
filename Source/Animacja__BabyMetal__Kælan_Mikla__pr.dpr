program Animacja__BabyMetal__Kælan_Mikla__pr;

uses
  Vcl.Forms,
  Animacja__BabyMetal__Kælan_Mikla in 'Animacja__BabyMetal__Kælan_Mikla.pas' {Animacja__BabyMetal__Kaelan_Mikla__Form};

{$R *.res}

begin

  //???ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  Application.Initialize();
  Application.MainFormOnTaskbar := True;
  Application.HintHidePause := 30000;
  Application.CreateForm(TAnimacja__BabyMetal__Kaelan_Mikla__Form, Animacja__BabyMetal__Kaelan_Mikla__Form);
  Application.Run();

end.
