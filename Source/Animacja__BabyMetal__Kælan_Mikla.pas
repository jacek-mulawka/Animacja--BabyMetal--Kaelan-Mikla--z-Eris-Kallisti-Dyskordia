unit Animacja__BabyMetal__Kælan_Mikla;{22.Wrz.2022}

  //
  // MIT License
  //
  // Copyright (c) 2022 Jacek Mulawka
  //
  // j.mulawka@interia.pl
  //
  // https://github.com/jacek-mulawka
  //


  // Kierunki współrzędnych układu głównego.
  //
  //     góra y
  //     przód -z
  // lewo -x
  //     tył z
  //

  // Plik ini
  //   animacja__oczekiwanie_do_rozpoczęcia_milisekundy - po jakim czasie od startu rozpocznie się animacja.
  //   animacja__oczekiwanie_do_rozpoczęcia_kolejnego_kroku_milisekundy - po jakim czasie od zakończenia jednego kroku animacji rozpocznie się kolejny krok animacji.
  //   animacja__promień - w jakiej odległości elementy sąsiadujące z elementem wybranym do animacji są razem wyznaczane do animacji.
  //   animacja__rodzaj__zalecana - obsługiwane wartości: '', 'BabyMetal', 'Kælan Mikla'. Informuje do jakiego rodzaju animacji został przygotowany schemat.
  //   animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy - po jakim czasie od zakończenia animacji zostanie wyłączony efekt śniegu.
  //     Wartość ujemna oznacza, że efekt śniegu nie zostanie wyłączony.
  //   falowanie__kolumna_następna__oczekiwanie__milisekundy - po jakim czasie od rozpoczęcia falowania poprzedniej kolumny rozpocznie się falowanie kolejnej kolumny.
  //   falowanie__szybkość - długość fali
  //     0 > i < 1 = długa fala;
  //     > 1 = krótka fala.
  //   falowanie__włączone - czy dla animacji ma być włączane falowanie elementów: 0 = false; 1 = true.
  //   losowanie__elementu__ilość_jednocześnie - ile elementów za jednym razem jest wybieranych do animacji.
  //     <= 0 = wartość zostanie wyliczona automatycznie.
  //   losowanie__rozbłysku__kolejne_milisekundy - zakres wartości czasu co jaki mogą odbywać się losowania (jest to wartość wzorcowa - z niej losuje się wartość czasu oczekiwania).
  //     Wartość ujemna oznacza, że efekt rozbłysku nie zostanie włączony.
  //   śnieg__efekt__margines - efekty śniegu są ustawiane na szerokości od najbardziej na lewo do najbardziej na prawo wysuniętego elementu animacji.
  //     Odświeżenie wartości wymaga ponownego wczytania schematu.
  //     Parametr oznacza o jaką wartość należy zmienić szerokość ustawiania efektów śniegu (jako marginesy po bokach).
  //     0 = domyślnie, bez marginesu;
  //     > 0 = zwiększa bo bokach margines ustawiania efektów śniegu.
  //   śnieg__efekt__rzadkość - efekty śniegu są ustawiane w linii (oś x).
  //     Odświeżenie wartości wymaga ponownego wczytania schematu.
  //     Parametr oznacza jak blisko siebie są kolejne 'efekty'.
  //     0 = brak efektu śniegu;
  //     1 = domyślnie, jeden przy drugim;
  //     0 > i < 1 = ilość efektów wzrasta (są gęściej układane - w mniejszych odstępach);
  //     > 1 = ilość efektów maleje (są rzadziej układane - w większych odstępach).
  //   śnieg__efekt__visible_at_run_time - 0 = false; 1 = true.
  //


  //
  //  Whenever We are on your side.
  //  Remember Always on your side.
  //                from 'The One'
  //
  //  Wherever we are, we’ll be with you.
  //  Wherever you are, you live in my heart.
  //                        from 'Starlight'
  //
  //                         by BabyMetal
  //
  //
  //
  //  Kveðskapur brotinna hjarta
  //
  //            by Kælan Mikla
  //
  //
  //
  //         bráðum
  //                     kemur
  //                                  sólin
  //
  //
  //  from 'Ætli Það Sé Óhollt Að Láta Sig Dreyma?'
  //
  //
  //            by Kælan Mikla
  //


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  GLWin32Viewer, GLObjects, GLScene, GLCoordinates, GLCrossPlatform, GLBaseClasses, GLNavigator, GLCadencer,
  GLFireFX, GLSkydome, GLAsyncTimer, GLHUDObjects, GLBitmapFont, GLWindowsFont,
  GLKeyboard, GLColor, GLMaterial, GLVectorGeometry,
  System.Math, System.DateUtils, System.StrUtils, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.Imaging.GIFImg,
  System.IOUtils, System.TypInfo, System.IniFiles, Winapi.ShellAPI;

type
  TAnimacja_Element_Etap = ( aee_Brak, aee_Animacja_Zakończona, aee_Element_Animowany );
  TAnimacja_Etap = ( ae_Brak, ae_Animacja_Zakończona, ae_Schemat_Animowany, ae_Schemat_Przygotowany, ae_Schemat_Wczytany );
  TAnimacja_Rodzaj = ( ar_BabyMetal, ar_Kælan_Mikla );

  TSchemat_Ustawienia_r = record
    falowanie__włączone,
    śnieg__efekt__visible_at_run_time
      : boolean;

    animacja__oczekiwanie_do_rozpoczęcia_milisekundy,
    animacja__oczekiwanie_do_rozpoczęcia_kolejnego_kroku_milisekundy,
    animacja__promień,
    animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy,
    element__efekt__particle_life,
    falowanie__kolumna_następna__oczekiwanie__milisekundy,
    losowanie__elementu__ilość_jednocześnie,
    losowanie__elementu__kolejne_milisekundy,
    losowanie__rozbłysku__kolejne_milisekundy,
    śnieg__efekt__particle_life,
    śnieg__rozbłysk__nb_particles,
    śnieg__rozbłysk__particle_life,
    wiatr__siła_maksymalna,
    wiatr__zmiana_kolejna__sekundy
      : integer;

    animacja__szybkość_zmiany_przeźroczystości : double;


    element__efekt__fire_burst,
    element__efekt__fire_crown,
    element__efekt__fire_density,
    //element__efekt__fire_dir_y,
    element__efekt__fire_evaporation,
    element__efekt__fire_radius,
    //element__efekt__initial_dir_y,
    element__efekt__kolor__inner__r,
    element__efekt__kolor__inner__g,
    element__efekt__kolor__inner__b,
    element__efekt__kolor__outer__r,
    element__efekt__kolor__outer__g,
    element__efekt__kolor__outer__b,
    element__efekt__particle_interval,
    element__efekt__particle_size,
    element__efekt__skala,

    element__kolor__r,
    element__kolor__g,
    element__kolor__b,

    element__skala,

    falowanie__amplituda,
    falowanie__szybkość,

    śnieg__efekt__fire_burst,
    śnieg__efekt__fire_crown,
    śnieg__efekt__fire_density,
    //śnieg__efekt__fire_dir_y,
    śnieg__efekt__fire_evaporation,
    śnieg__efekt__fire_radius,
    //śnieg__efekt__initial_dir_y,
    śnieg__efekt__kolor__inner__r,
    śnieg__efekt__kolor__inner__g,
    śnieg__efekt__kolor__inner__b,
    śnieg__efekt__kolor__outer__r,
    śnieg__efekt__kolor__outer__g,
    śnieg__efekt__kolor__outer__b,
    śnieg__efekt__margines,
    śnieg__efekt__particle_interval,
    śnieg__efekt__particle_size,
    śnieg__efekt__rzadkość,
    śnieg__efekt__skala,

    śnieg__efekt__pozycja_y,

    śnieg__rozbłysk__fire_burst,
    śnieg__rozbłysk__fire_crown,
    śnieg__rozbłysk__fire_density,
    śnieg__rozbłysk__fire_evaporation,
    śnieg__rozbłysk__fire_radius,
    śnieg__rozbłysk__kolor__inner__r,
    śnieg__rozbłysk__kolor__inner__g,
    śnieg__rozbłysk__kolor__inner__b,
    śnieg__rozbłysk__kolor__outer__r,
    śnieg__rozbłysk__kolor__outer__g,
    śnieg__rozbłysk__kolor__outer__b,
    śnieg__rozbłysk__life_boost_factor,
    śnieg__rozbłysk__max_initial_speed,
    śnieg__rozbłysk__min_initial_speed,
    śnieg__rozbłysk__particle_interval,
    śnieg__rozbłysk__particle_size,
    śnieg__rozbłysk__skala,

    tło__kolor__r,
    tło__kolor__g,
    tło__kolor__b
      : single;

    animacja__rodzaj_su : TAnimacja_Rodzaj;

    animacja__rodzaj__zalecana_s_su : string;
  end;//---//TSchemat_Ustawienia_r

  TSchemat_Element = class( TGLDummyCube )
    private
      falowanie__aktywne : boolean;

      animacja__krok,
      kolumna,
      wiersz
        : integer;

      efekt_gl_dummy_cube__position__z__kopia,
      falowanie__przesunięcie // Aktualna pozycja na osi x podczas obliczania wartości dla sinusa (od 0 do 2 pi). Nie jest powiązane z układem współrzędnych sceny.
        : single;

      animacja__element_etap : TAnimacja_Element_Etap;
      animacja__rodzaj__se : TAnimacja_Rodzaj;
      element_gl_cube : TGLCube;
      efekt_gl_dummy_cube : TGLDummyCube;
      efekt_gl_fire_fx_manager : TGLFireFXManager;
  public
    { Public declarations }
    constructor Create( AOwner : TComponent; AParent : TGLBaseSceneObject; gl_cadencer_f : TGLCadencer );
    destructor Destroy(); override;

    procedure Animacja_Parametry_Początkowe_Ustaw();
    procedure Parametry__Sprawdź( const y__min_f : single );
    procedure Parametry__Ustaw( const schemat_ustawienia_r_f : TSchemat_Ustawienia_r; const x_f, y_f : single; const współrzędne_pomiń_f : boolean = false );
  end;//---//TSchemat_Element

  TŚnieg_Efekt = class( TGLDummyCube )
    private
      animacja__rodzaj__śe : TAnimacja_Rodzaj;
      efekt_gl_fire_fx_manager : TGLFireFXManager;
  public
    { Public declarations }
    constructor Create( AOwner : TComponent; AParent : TGLBaseSceneObject; gl_cadencer_f : TGLCadencer );
    destructor Destroy(); override;

    procedure Animacja_Parametry_Początkowe_Ustaw();
    procedure Parametry__Sprawdź( const y__min_f : single );
    procedure Parametry__Ustaw( const schemat_ustawienia_r_f : TSchemat_Ustawienia_r; const y__min_f : single );
  end;//---//TSchemat_Element

  TAnimacja__BabyMetal__Kaelan_Mikla__Form = class( TForm )
    Gra_GLSceneViewer: TGLSceneViewer;
    Gra_GLScene: TGLScene;
    Gra_GLCamera: TGLCamera;
    Gra_GLLightSource: TGLLightSource;
    Zero_GLSphere: TGLSphere;
    Lewo_GLCube: TGLCube;
    GLCadencer1: TGLCadencer;
    GLNavigator1: TGLNavigator;
    GLUserInterface1: TGLUserInterface;
    PageControl1: TPageControl;
    Opcje_Splitter: TSplitter;
    Opcje_TabSheet: TTabSheet;
    O_Programie_TabSheet: TTabSheet;
    O_Programie_Label: TLabel;
    Logo_Image: TImage;
    Gra_Obiekty_GLDummyCube: TGLDummyCube;
    Animacja_Rodzaj_RadioGroup: TRadioGroup;
    Schematy_Etykieta_Label: TLabel;
    Schematy_Informacja_Label: TLabel;
    Schematy_ComboBox: TComboBox;
    Start_BitBtn: TBitBtn;
    Stop_BitBtn: TBitBtn;
    Pauza_Button: TButton;
    Pomoc_BitBtn: TBitBtn;
    GLSkyDome1: TGLSkyDome;
    Animacja_Zakończona_Label: TLabel;
    Kamera_Ustaw_CheckBox: TCheckBox;
    Konwerter_Obrazów_TabSheet: TTabSheet;
    Konwerter_Obrazów__Góra_Panel: TPanel;
    Konwerter_Obrazów__Obraz_Adres_Etykieta_Label: TLabel;
    Konwerter_Obrazów__Obraz_Adres_Edit: TEdit;
    Konwerter_Obrazów__Obraz_Adres__Szukaj_Button: TButton;
    Konwerter_Obrazów__Obraz_Wczytaj_Button: TButton;
    Konwerter_Obrazów__Obraz_Konwertuj_Button: TButton;
    Konwerter_Obrazów__Obraz_Zapisz_Button: TButton;
    Konwerter_Obrazów__Obraz_Image: TImage;
    Konwerter_Obrazów__OpenDialog: TOpenDialog;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    Gra_Współczynnik_Prędkości_Etykieta_Label: TLabel;
    Gra_Współczynnik_Prędkości_Label: TLabel;
    Gra_Współczynnik_Prędkości__Zmniejsz_Button: TButton;
    Gra_Współczynnik_Prędkości__Domyślny_Button: TButton;
    Gra_Współczynnik_Prędkości__Zwiększ_Button: TButton;
    Animacja_Etap_Label: TLabel;
    Elementy_Ilość_Label: TLabel;
    Kursor_GLAsyncTimer: TGLAsyncTimer;
    X_Y_Min_Max_Label: TLabel;
    Śnieg_Efekt_Ilość: TLabel;
    Przerwij_Wczytywanie_Schematu_BitBtn: TBitBtn;
    Informacja_Ekranowa_CheckBox: TCheckBox;
    Gra_GLWindowsBitmapFont: TGLWindowsBitmapFont;
    Informacja_Ekranowa_GLHUDSprite: TGLHUDSprite;
    Informacja_Ekranowa_GLHUDText: TGLHUDText;
    Informacja_Ekranowa_Timer: TTimer;
    BabyMetal_LinkLabel: TLinkLabel;
    Kælan_Mikla_LinkLabel: TLinkLabel;
    Źródła_Etykieta_Label: TLabel;
    Falowanie_CheckBox: TCheckBox;
    Ustawiena_Według_Schematu_Ustaw_CheckBox: TCheckBox;
    Pasek_Postępu_Wyświetlaj_CheckBox: TCheckBox;
    ProgressBar1__Widoczność_Splitter: TSplitter;
    procedure FormShow( Sender: TObject );
    procedure FormClose( Sender: TObject; var Action: TCloseAction );
    procedure FormResize( Sender: TObject );
    procedure Animacja__BabyMetal__Kælan_Mikla_MouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer );
    procedure GLCadencer1Progress( Sender: TObject; const deltaTime, newTime: Double );
    procedure Gra_GLSceneViewerClick( Sender: TObject );
    procedure Gra_GLSceneViewerMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer );
    procedure Gra_GLSceneViewerKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState );
    procedure PageControl1Resize( Sender: TObject );
    procedure Falowanie_CheckBoxClick( Sender: TObject );
    procedure Informacja_Ekranowa_TimerTimer( Sender: TObject );
    procedure Kursor_GLAsyncTimerTimer( Sender: TObject );
    procedure Schematy_ComboBoxChange( Sender: TObject );
    procedure Schematy_ComboBoxKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState );
    procedure Start_BitBtnClick( Sender: TObject );
    procedure Stop_BitBtnClick( Sender: TObject );
    procedure Pauza_ButtonClick( Sender: TObject );
    procedure Pomoc_BitBtnClick( Sender: TObject );
    procedure Przerwij_Wczytywanie_Schematu_BitBtnClick( Sender: TObject );
    procedure Konwerter_Obrazów__Obraz_Adres__Szukaj_ButtonClick( Sender: TObject );
    procedure Konwerter_Obrazów__Obraz_Wczytaj_ButtonClick( Sender: TObject );
    procedure Konwerter_Obrazów__Obraz_Zapisz_ButtonClick( Sender: TObject );
    procedure Gra_Współczynnik_Prędkości__Zmniejsz_ButtonClick( Sender: TObject );
    procedure Gra_Współczynnik_Prędkości__Domyślny_ButtonClick( Sender: TObject );
    procedure Gra_Współczynnik_Prędkości__Zwiększ_ButtonClick( Sender: TObject );
    procedure LinkLabelLinkClick( Sender: TObject; const Link: string; LinkType: TSysLinkType );
  private
    { Private declarations }
    // Jeżeli animacja zawiera kroki oznacza to, że pewne grupy elementów są animowane w danym kroku
    // i gdy wszystkie elementy z danego kroku zakończą swoją animację, rozpocznie się kolejny krok animacji.
    //
    // Kroki powinny być zdefiniowane po kolei, rosnąco z zachowaniem ciągłości np.: 1, 2, 3.
    animacja__krokowa_g,
    falowanie__kolumny_wszystkie_falują_g,
    //falowanie__pytanie_zadane_g, // Czy pytanie o zgodność ustawień animacji ze schematem aniamcji zostało zadane.
    przerwij_wczytywanie_schematu_g,
    trwa__wczytywanie_schematu_g,
    trwa__zwalnianie_schematu_g
      : boolean;

    animacja__krok__aktualny_g,
    animacja__krok__aktualny_kopia_g,
    animacja__krok__ostatni_g,
    losowanie__elementu__kolejne__zakres__czas_milisekundy_i, // Zakres wartości czasu co jaki mogą odbywać się losowania (jest to wartość wzorcowa  z niej losuje się wartość czasu oczekiwania).
    losowanie__elementu__kolejne__losowy__czas_milisekundy_i, // Czas do kolejnego losowania (wartość modyfikowana losowo).
    losowanie__rozbłysku__kolejne__zakres__czas_milisekundy_i, // Zakres wartości czasu co jaki mogą odbywać się losowania (jest to wartość wzorcowa - z niej losuje się wartość czasu oczekiwania). Wartość ujemna oznacza, że efekt rozbłysku nie zostanie włączony.
    losowanie__rozbłysku__kolejne__losowy__czas_milisekundy_i, // Czas do kolejnego losowania (wartość modyfikowana losowo).
    wiatr_zmiana_kolejna__czas_sekundy_i, // Co jaki czas odbywają się zmiana wiatru.
    wiatr_zmiana_kolejna__czas_sekundy_losowy_i // Losowa modyfikacja czasu zmiany wiatru.
      : integer;

    animacja__etap__czas_milisekundy_i, // Czas rozpoczęcia aktualnego etapu animacji.
    animacja__krok_czas_milisekundy_i, // Czas rozpoczęcia odliczania przerwy między kolejnymi krokami animacji.
    falowanie__kolumna_poprzednia__falowanie_rozpoczęcie_czas_milisekundy_i, // Czas rozpoczęcia odliczania przerwy między falowaniem kolejnych kolumn.
    losowanie__elementu__ostatnie_czas_milisekundy_i, // Czas ostatniego wylosowania elementu do animacji.
    losowanie__rozbłysku__ostatnie_czas_milisekundy_i, // Czas ostatniego wylosowania rozbłysku.
    wiatr_czas_sekundy_i // Czas poprzedniej zmiany wiatru.
      : Int64;

    gra_współczynnik_prędkości_g : currency;

    y__min_g : single;

    //animacja__etap__czas_zmiany_ostatniej_g,
    kursor_ruch_ostatni_data_czas_g
      : TDateTime;

    schemat_wczytany_g : string;

    animacja__etap_g : TAnimacja_Etap;

    schemat_ustawienia_r_g : TSchemat_Ustawienia_r;

    rozbłyski_losowanie_t, // Tabela zawiera indeksy elementów schematu możliwych do wyświetlania efektów rozbłysków.
    schemat_elementy_losowanie_t // Tabela zawiera indeksy elementów schematu możliwych do animacji w danym kroku.
      : array of integer;

    schemat_elementy_list,
    śnieg_efekt_list
      : TList;

    function Komunikat_Wyświetl( const text_f, caption_f : string; const flags_f : integer ) : integer;
    procedure Kamera_Ruch( delta_czasu_f : double );

    function Czy_Pauza() : boolean;
    procedure Pauza();

    procedure Gra_Współczynnik_Prędkości_Zmień( const zmiana_kierunek_f : smallint );
    procedure Informacja_Ekranowa_Wyświetl( const napis_f : string );

    procedure Animacja_Etap_Informacja();
    procedure Animacja_Parametry_Początkowe_Ustaw();
    procedure Animuj( const delta_czasu_f : double );

    procedure Falowanie( const delta_czasu_f : double );

    procedure ProgressBar1__Widoczność_Ustaw( const widoczny_f : boolean = true );

    procedure Rozbłyski__Losowanie_Element_Indeks_Dodaj( const element_indeks_f : integer );
    procedure Rozbłyski__Losowanie_Przygotuj();
    procedure Rozbłyski__Losuj();

    procedure Schemat__Kamera_Ustaw();
    procedure Schemat__Lista_Wczytaj();
    procedure Schemat__Losowanie_Przygotuj();
    procedure Schemat__Losuj();
    procedure Schemat__Odśwież();
    procedure Schemat__Ustawienia_Odśwież();
    function Schemat__Wczytaj() : boolean;
    procedure Schemat__Zwolnij();

    procedure Ustawienia_Plik( const schemat_nazwa_f : string; const zapisuj_ustawienia_f : boolean = false );

    procedure Wiatr_Śnieg__Losuj();
  public
    { Public declarations }
  end;

const
  animacja__rodzaj__zalecana__nazwa__BabyMetal_c : string =  'babymetal';
  animacja__rodzaj__zalecana__nazwa__Kælan_Mikla_c : string =  'kælan mikla'; // Plik ini chyba działa w formacie Unicode.
  schematy_katalog_nazwa_c : string = 'Schematy';
  plik_ini_wzorcowy_nazwa_c : string = '0 wzór';
  postęp_odświeżanie_milisekundy_c : Int64 = 1500; // Co jaki czas odświeżać informacje o postępie.

var
  Animacja__BabyMetal__Kaelan_Mikla__Form: TAnimacja__BabyMetal__Kaelan_Mikla__Form;

  function Czas_Między_W_Sekundach( const czas_poprzedni_f : Int64; const zmienna_w_milisekundach_f : boolean = false ) : Int64;
  function Czas_Między_W_Milisekundach( const czas_poprzedni_f : Int64; const zmienna_w_milisekundach_f : boolean = false ) : Int64;
  function Czas_Teraz() : double;
  function Czas_Teraz_W_Sekundach() : Int64;
  function Czas_Teraz_W_Milisekundach() : Int64;

  //
  // Przykład użycia:
  //  czas_sekundy,
  //  czas_milisekundy
  //    : Int64
  //
  //  czas_sekundy := Czas_Teraz_W_Sekundach() // 1 sekunda = 1.
  //  Czas_Między_W_Sekundach( czas_sekundy ) // 1 sekunda = 1.
  //  Czas_Między_W_Milisekundach( czas_sekundy ) // 1 sekunda = 1 000.
  //
  //  czas_milisekundy := Czas_Teraz_W_Milisekundach() // 1 sekunda = 1 000.
  //  Czas_Między_W_Sekundach( czas_milisekundy, true ) // 1 sekunda = 1.
  //  Czas_Między_W_Milisekundach( czas_milisekundy, true ) // 1 sekunda = 1 000.
  //

  //
  // zdarzenie_trwanie_sekundy_czas : integer; // Czas trwania jakiegoś zdarzenia.
  // zdarzenie_sekundy_czas_i : Int64; // Czas zaistnienia jakiegoś zdarzenia.
  //
  // zdarzenie_trwanie_sekundy_czas := Random( 11 );
  // zdarzenie_sekundy_czas_i := Czas_Teraz_W_Sekundach();
  //
  // if Czas_Między_W_Sekundach( zdarzenie_sekundy_czas_i ) > zdarzenie_trwanie_sekundy_czas then
  //

implementation

{$R *.dfm}

//Konstruktor klasy TSchemat_Element.
constructor TSchemat_Element.Create( AOwner : TComponent; AParent : TGLBaseSceneObject; gl_cadencer_f : TGLCadencer );
begin

  inherited Create( AOwner );

  Self.Parent := AParent;
  Self.Visible := false; // Też przyśpiesza działanie.

  Self.animacja__krok := 1;
  Self.animacja__element_etap := aee_Brak;
  Self.animacja__rodzaj__se := ar_BabyMetal;
  Self.efekt_gl_dummy_cube__position__z__kopia := 0;
  Self.falowanie__aktywne := false;
  Self.falowanie__przesunięcie := 0;
  Self.kolumna := 0;
  Self.wiersz := 0;

  Self.element_gl_cube := TGLCube.Create( Self );
  Self.element_gl_cube.Parent := Self;
  Self.element_gl_cube.Material.FrontProperties.Ambient.Color := GLColor.clrTransparent;
  Self.element_gl_cube.Material.FrontProperties.Emission.Color := GLColor.clrTransparent;
  Self.element_gl_cube.Material.BlendingMode := GLMaterial.bmTransparency;

  Self.efekt_gl_dummy_cube := TGLDummyCube.Create( Self );
  //Self.efekt_gl_dummy_cube.Parent := Self; // Nie widać efektów na tle elementów.
  Self.efekt_gl_dummy_cube.Parent := AParent; // Nie widać efektów na tle elementów.
  Self.efekt_gl_dummy_cube.Scale.Scale( 0.5 );
  //Self.efekt_gl_dummy_cube.VisibleAtRunTime := true; //???

  Self.efekt_gl_fire_fx_manager := TGLFireFXManager.Create( Self );
  Self.efekt_gl_fire_fx_manager.Cadencer := gl_cadencer_f;
  Self.efekt_gl_fire_fx_manager.Disabled := true;
  Self.efekt_gl_fire_fx_manager.FireBurst := 0.1;
  Self.efekt_gl_fire_fx_manager.FireCrown := 1;
  Self.efekt_gl_fire_fx_manager.FireDensity := 8;
  Self.efekt_gl_fire_fx_manager.FireDir.Y := -0.5;
  Self.efekt_gl_fire_fx_manager.FireEvaporation := 1.3;
  Self.efekt_gl_fire_fx_manager.FireRadius := 0.1;
  Self.efekt_gl_fire_fx_manager.InitialDir.Y := -1;
  Self.efekt_gl_fire_fx_manager.ParticleInterval := 0.25;
  Self.efekt_gl_fire_fx_manager.ParticleLife := 40;
  Self.efekt_gl_fire_fx_manager.ParticleSize := 0.4;
  Self.efekt_gl_fire_fx_manager.InnerColor.Color := Self.element_gl_cube.Material.FrontProperties.Diffuse.Color;
  Self.efekt_gl_fire_fx_manager.OuterColor.Color := GLColor.clrWhite;

  // Dodaje efekt.
  GetOrCreateFireFX( Self.efekt_gl_dummy_cube ).Manager := Self.efekt_gl_fire_fx_manager;

end;//---//Konstruktor klasy TSchemat_Element.

//Destruktor klasy TSchemat_Element.
destructor TSchemat_Element.Destroy();
begin

  FreeAndNil( Self.efekt_gl_fire_fx_manager );
  FreeAndNil( Self.efekt_gl_dummy_cube );
  FreeAndNil( Self.element_gl_cube );

  inherited;

end;//---//Destruktor klasy TSchemat_Element.

//Funkcja Animacja_Parametry_Początkowe_Ustaw().
procedure TSchemat_Element.Animacja_Parametry_Początkowe_Ustaw();
begin

  Self.animacja__element_etap := aee_Brak;
  Self.efekt_gl_fire_fx_manager.Disabled := true;
  Self.efekt_gl_fire_fx_manager.FireDir.X := 0;
  Self.falowanie__aktywne := false;
  Self.falowanie__przesunięcie := 0;
  Self.Position.Z := 0;
  Self.efekt_gl_dummy_cube.Position.Z := Self.Position.Z
    + Self.efekt_gl_dummy_cube__position__z__kopia;


  if Self.animacja__rodzaj__se = ar_BabyMetal then
    begin

      Self.element_gl_cube.Material.FrontProperties.Diffuse.Alpha := 1;

      Self.efekt_gl_fire_fx_manager.FireDir.Y := -0.5;
      Self.efekt_gl_fire_fx_manager.InitialDir.Y := -1;

    end
  else//if Self.animacja__rodzaj__se = ar_BabyMetal then
  if Self.animacja__rodzaj__se = ar_Kælan_Mikla then
    begin

      Self.element_gl_cube.Material.FrontProperties.Diffuse.Alpha := 0;

      Self.efekt_gl_fire_fx_manager.FireDir.Y := 0;
      Self.efekt_gl_fire_fx_manager.InitialDir.Y := 0;

    end;
  //---//if Self.animacja__rodzaj__se = ar_Kælan_Mikla then


  if not Self.Visible then
    Self.Visible := true;

end;//---//Funkcja Animacja_Parametry_Początkowe_Ustaw().

//Funkcja Parametry__Sprawdź().
procedure TSchemat_Element.Parametry__Sprawdź( const y__min_f : single );
begin

  // x__min_f - lewo.
  // x__max_f - prawo.
  // y__min_f - dół.
  // y__max_f - Góra.

  if Self.efekt_gl_fire_fx_manager.ParticleLife <= 0 then
    Self.efekt_gl_fire_fx_manager.ParticleLife := Round(  Abs( y__min_f ) * 0.5  );

  if Self.efekt_gl_fire_fx_manager.ParticleLife <= 0 then
    Self.efekt_gl_fire_fx_manager.ParticleLife := 40;

end;//---//Funkcja Parametry__Sprawdź().

//Funkcja Parametry__Ustaw().
procedure TSchemat_Element.Parametry__Ustaw( const schemat_ustawienia_r_f : TSchemat_Ustawienia_r; const x_f, y_f : single; const współrzędne_pomiń_f : boolean = false );
begin

  Self.animacja__rodzaj__se := schemat_ustawienia_r_f.animacja__rodzaj_su;

  Self.element_gl_cube.Scale.X := schemat_ustawienia_r_f.element__skala;
  Self.element_gl_cube.Scale.Y := schemat_ustawienia_r_f.element__skala;
  Self.element_gl_cube.Scale.Z := schemat_ustawienia_r_f.element__skala;

  Self.element_gl_cube.Material.FrontProperties.Diffuse.Color := GLVectorGeometry.VectorMake( schemat_ustawienia_r_f.element__kolor__r, schemat_ustawienia_r_f.element__kolor__g, schemat_ustawienia_r_f.element__kolor__b, Self.element_gl_cube.Material.FrontProperties.Diffuse.Alpha );

  if Self.animacja__rodzaj__se = ar_Kælan_Mikla then
    begin

      Self.efekt_gl_dummy_cube.Scale.X := schemat_ustawienia_r_f.śnieg__rozbłysk__skala;
      Self.efekt_gl_dummy_cube.Scale.Y := schemat_ustawienia_r_f.śnieg__rozbłysk__skala;
      Self.efekt_gl_dummy_cube.Scale.Z := schemat_ustawienia_r_f.śnieg__rozbłysk__skala;

      Self.efekt_gl_fire_fx_manager.FireBurst := schemat_ustawienia_r_f.śnieg__rozbłysk__fire_burst;
      Self.efekt_gl_fire_fx_manager.FireCrown := schemat_ustawienia_r_f.śnieg__rozbłysk__fire_crown;
      Self.efekt_gl_fire_fx_manager.FireDensity := schemat_ustawienia_r_f.śnieg__rozbłysk__fire_density;
      Self.efekt_gl_fire_fx_manager.FireEvaporation := schemat_ustawienia_r_f.śnieg__rozbłysk__fire_evaporation;
      Self.efekt_gl_fire_fx_manager.FireRadius := schemat_ustawienia_r_f.śnieg__rozbłysk__fire_radius;
      Self.efekt_gl_fire_fx_manager.ParticleInterval := schemat_ustawienia_r_f.śnieg__rozbłysk__particle_interval;
      Self.efekt_gl_fire_fx_manager.ParticleLife := schemat_ustawienia_r_f.śnieg__rozbłysk__particle_life;
      Self.efekt_gl_fire_fx_manager.ParticleSize := schemat_ustawienia_r_f.śnieg__rozbłysk__particle_size;
      Self.efekt_gl_fire_fx_manager.InnerColor.Color := GLVectorGeometry.VectorMake( schemat_ustawienia_r_f.śnieg__rozbłysk__kolor__inner__r, schemat_ustawienia_r_f.śnieg__rozbłysk__kolor__inner__g, schemat_ustawienia_r_f.śnieg__rozbłysk__kolor__inner__b, 1 );
      Self.efekt_gl_fire_fx_manager.OuterColor.Color := GLVectorGeometry.VectorMake( schemat_ustawienia_r_f.śnieg__rozbłysk__kolor__outer__r, schemat_ustawienia_r_f.śnieg__rozbłysk__kolor__outer__g, schemat_ustawienia_r_f.śnieg__rozbłysk__kolor__outer__b, 1 );

    end
  else//if Self.animacja__rodzaj__se = ar_Kælan_Mikla then
    begin

      Self.efekt_gl_dummy_cube.Scale.X := schemat_ustawienia_r_f.element__efekt__skala;
      Self.efekt_gl_dummy_cube.Scale.Y := schemat_ustawienia_r_f.element__efekt__skala;
      Self.efekt_gl_dummy_cube.Scale.Z := schemat_ustawienia_r_f.element__efekt__skala;

      Self.efekt_gl_fire_fx_manager.FireBurst := schemat_ustawienia_r_f.element__efekt__fire_burst;
      Self.efekt_gl_fire_fx_manager.FireCrown := schemat_ustawienia_r_f.element__efekt__fire_crown;
      Self.efekt_gl_fire_fx_manager.FireDensity := schemat_ustawienia_r_f.element__efekt__fire_density;
      //Self.efekt_gl_fire_fx_manager.FireDir.Y := schemat_ustawienia_r_f.element__efekt__fire_dir_y;
      Self.efekt_gl_fire_fx_manager.FireEvaporation := schemat_ustawienia_r_f.element__efekt__fire_evaporation;
      Self.efekt_gl_fire_fx_manager.FireRadius := schemat_ustawienia_r_f.element__efekt__fire_radius;
      //Self.efekt_gl_fire_fx_manager.InitialDir.Y := schemat_ustawienia_r_f.element__efekt__initial_dir_y;
      Self.efekt_gl_fire_fx_manager.ParticleInterval := schemat_ustawienia_r_f.element__efekt__particle_interval;
      Self.efekt_gl_fire_fx_manager.ParticleLife := schemat_ustawienia_r_f.element__efekt__particle_life;
      Self.efekt_gl_fire_fx_manager.ParticleSize := schemat_ustawienia_r_f.element__efekt__particle_size;
      Self.efekt_gl_fire_fx_manager.InnerColor.Color := GLVectorGeometry.VectorMake( schemat_ustawienia_r_f.element__efekt__kolor__inner__r, schemat_ustawienia_r_f.element__efekt__kolor__inner__g, schemat_ustawienia_r_f.element__efekt__kolor__inner__b, 1 );
      Self.efekt_gl_fire_fx_manager.OuterColor.Color := GLVectorGeometry.VectorMake( schemat_ustawienia_r_f.element__efekt__kolor__outer__r, schemat_ustawienia_r_f.element__efekt__kolor__outer__g, schemat_ustawienia_r_f.element__efekt__kolor__outer__b, 1 );

    end;
  //---//if Self.animacja__rodzaj__se = ar_Kælan_Mikla then


  if not współrzędne_pomiń_f then
    begin

      Self.Position.X := x_f * Self.element_gl_cube.Scale.X;
      Self.Position.Y := y_f * Self.element_gl_cube.Scale.X;

      Self.kolumna := Round( x_f );
      Self.wiersz := Round( y_f );

    end;
  //---//if not współrzędne_pomiń_f then

  Self.efekt_gl_dummy_cube.Position := Self.Position; // Nie widać efektów na tle elementów.
  Self.efekt_gl_dummy_cube.Position.Y := Self.efekt_gl_dummy_cube.Position.Y - Self.element_gl_cube.Scale.X * 0.25 - Self.efekt_gl_dummy_cube.Scale.X * 0.25;
  Self.efekt_gl_dummy_cube.Position.Z := Self.element_gl_cube.Scale.X * 0.5 + Self.efekt_gl_dummy_cube.Scale.X * 0.5;
  Self.efekt_gl_dummy_cube__position__z__kopia := Self.efekt_gl_dummy_cube.Position.Z;

  //if not Self.Visible then //???
  //  Self.Visible := true;

end;//---//Funkcja Parametry__Ustaw().

//Konstruktor klasy TŚnieg_Efekt.
constructor TŚnieg_Efekt.Create( AOwner : TComponent; AParent : TGLBaseSceneObject; gl_cadencer_f : TGLCadencer );
begin

  inherited Create( AOwner );

  Self.Parent := AParent;

  Self.animacja__rodzaj__śe := ar_BabyMetal;

  Self.efekt_gl_fire_fx_manager := TGLFireFXManager.Create( Self );
  Self.efekt_gl_fire_fx_manager.Cadencer := gl_cadencer_f;
  Self.efekt_gl_fire_fx_manager.Disabled := true;
  Self.efekt_gl_fire_fx_manager.FireBurst := 0.5;
  Self.efekt_gl_fire_fx_manager.FireCrown := 20;
  Self.efekt_gl_fire_fx_manager.FireDensity := 12;
  Self.efekt_gl_fire_fx_manager.FireDir.Y := -0.5;
  Self.efekt_gl_fire_fx_manager.FireEvaporation := 2.2;
  Self.efekt_gl_fire_fx_manager.FireRadius := 1;
  Self.efekt_gl_fire_fx_manager.InitialDir.Y := -1;
  Self.efekt_gl_fire_fx_manager.ParticleInterval := 1;
  Self.efekt_gl_fire_fx_manager.ParticleLife := 50;
  Self.efekt_gl_fire_fx_manager.ParticleSize := 0.8;
  Self.efekt_gl_fire_fx_manager.InnerColor.Color := GLVectorGeometry.VectorMake( 1, 1, 1, 1 );
  Self.efekt_gl_fire_fx_manager.OuterColor.Color := GLVectorGeometry.VectorMake( 1, 1, 1, 1 );

  // Dodaje efekt.
  GetOrCreateFireFX( Self ).Manager := Self.efekt_gl_fire_fx_manager;

end;//---//Konstruktor klasy TŚnieg_Efekt.

//Destruktor klasy TŚnieg_Efekt.
destructor TŚnieg_Efekt.Destroy();
begin

  FreeAndNil( Self.efekt_gl_fire_fx_manager );

  inherited;

end;//---//Destruktor klasy TŚnieg_Efekt.

//Funkcja Animacja_Parametry_Początkowe_Ustaw().
procedure TŚnieg_Efekt.Animacja_Parametry_Początkowe_Ustaw();
begin

  Self.efekt_gl_fire_fx_manager.FireDir.X := 0;


  if Self.animacja__rodzaj__śe = ar_BabyMetal then
    begin

      Self.efekt_gl_fire_fx_manager.Disabled := true;

    end
  else//if Self.animacja__rodzaj__śe = ar_BabyMetal then
  if Self.animacja__rodzaj__śe = ar_Kælan_Mikla then
    begin

      Self.efekt_gl_fire_fx_manager.Disabled := false;

    end;
  //---//if Self.animacja__rodzaj__śe = ar_Kælan_Mikla then

end;//---//Funkcja Animacja_Parametry_Początkowe_Ustaw().

//Funkcja Parametry__Sprawdź().
procedure TŚnieg_Efekt.Parametry__Sprawdź( const y__min_f : single );
begin

  // x__min_f - lewo.
  // x__max_f - prawo.
  // y__min_f - dół.
  // y__max_f - Góra.

  if Self.efekt_gl_fire_fx_manager.ParticleLife <= 0 then
    Self.efekt_gl_fire_fx_manager.ParticleLife := Round(  Abs( y__min_f ) * 2  );
    //Self.efekt_gl_fire_fx_manager.ParticleLife := Round(  Abs( Self.Position.Y )  ) * 2;

  if Self.efekt_gl_fire_fx_manager.ParticleLife <= 0 then
    Self.efekt_gl_fire_fx_manager.ParticleLife := 80;

end;//---//Funkcja Parametry__Sprawdź().

//Funkcja Parametry__Ustaw().
procedure TŚnieg_Efekt.Parametry__Ustaw( const schemat_ustawienia_r_f : TSchemat_Ustawienia_r; const y__min_f : single );
begin

  Self.VisibleAtRunTime := schemat_ustawienia_r_f.śnieg__efekt__visible_at_run_time;

  Self.animacja__rodzaj__śe := schemat_ustawienia_r_f.animacja__rodzaj_su;

  Self.Scale.X := schemat_ustawienia_r_f.śnieg__efekt__skala;
  Self.Scale.Y := schemat_ustawienia_r_f.śnieg__efekt__skala;
  Self.Scale.Z := schemat_ustawienia_r_f.śnieg__efekt__skala;

  if schemat_ustawienia_r_f.śnieg__efekt__pozycja_y = -9999 then
    //Self.Position.Y := -y__min_f * 2 * Self.Scale.X
    Self.Position.Y := -y__min_f * Self.Scale.X * 0.5
  else//if schemat_ustawienia_r_f.śnieg__efekt__pozycja_y = -9999 then
    Self.Position.Y := schemat_ustawienia_r_f.śnieg__efekt__pozycja_y;

  Self.Position.Y := Self.Position.Y - Random(  Round( Self.Position.Y * 0.5 )  );

  Self.efekt_gl_fire_fx_manager.FireBurst := schemat_ustawienia_r_f.śnieg__efekt__fire_burst;
  Self.efekt_gl_fire_fx_manager.FireCrown := schemat_ustawienia_r_f.śnieg__efekt__fire_crown;
  Self.efekt_gl_fire_fx_manager.FireDensity := schemat_ustawienia_r_f.śnieg__efekt__fire_density;
  //Self.efekt_gl_fire_fx_manager.FireDir.Y := schemat_ustawienia_r_f.śnieg__efekt__fire_dir_y;
  Self.efekt_gl_fire_fx_manager.FireEvaporation := schemat_ustawienia_r_f.śnieg__efekt__fire_evaporation;
  Self.efekt_gl_fire_fx_manager.FireRadius := schemat_ustawienia_r_f.śnieg__efekt__fire_radius;
  //Self.efekt_gl_fire_fx_manager.InitialDir.Y := schemat_ustawienia_r_f.śnieg__efekt__initial_dir_y;
  Self.efekt_gl_fire_fx_manager.ParticleInterval := schemat_ustawienia_r_f.śnieg__efekt__particle_interval;
  Self.efekt_gl_fire_fx_manager.ParticleLife := schemat_ustawienia_r_f.śnieg__efekt__particle_life;
  Self.efekt_gl_fire_fx_manager.ParticleSize := schemat_ustawienia_r_f.śnieg__efekt__particle_size;
  Self.efekt_gl_fire_fx_manager.InnerColor.Color := GLVectorGeometry.VectorMake( schemat_ustawienia_r_f.śnieg__efekt__kolor__inner__r, schemat_ustawienia_r_f.śnieg__efekt__kolor__inner__g, schemat_ustawienia_r_f.śnieg__efekt__kolor__inner__b, 1 );
  Self.efekt_gl_fire_fx_manager.OuterColor.Color := GLVectorGeometry.VectorMake( schemat_ustawienia_r_f.śnieg__efekt__kolor__outer__r, schemat_ustawienia_r_f.śnieg__efekt__kolor__outer__g, schemat_ustawienia_r_f.śnieg__efekt__kolor__outer__b, 1 );

end;//---//Funkcja Parametry__Ustaw().


//      ***      Funkcje      ***      //

//Funkcja Czas_Między_W_Sekundach().
function Czas_Między_W_Sekundach( const czas_poprzedni_f : Int64; const zmienna_w_milisekundach_f : boolean = false ) : Int64;
begin

  //
  // Funkcja wylicza ilość sekund bezwzględnego czasu gry jaka upłynęła od podanego czasu do chwili obecnej.
  //
  // Zwraca ilość sekund bezwzględnego czasu gry w postaci 123 (1:59 = 1).
  //
  // Parametry:
  //   czas_poprzedni_f - moment czasu gry, od którego liczyć upływ czasu.
  //   zmienna_w_milisekundach_f
  //     false - zmienna czas_poprzedni_f przechowuje wartość w sekundach (wartość zmiennej dla 1 sekunda = 1).
  //     true - zmienna czas_poprzedni_f przechowuje wartość w milisekundach (wartość zmiennej dla 1 sekunda = 1 000).
  //

  Result := Floor(  Czas_Między_W_Milisekundach( czas_poprzedni_f, zmienna_w_milisekundach_f ) * 0.001  );

end;//---//Funkcja Czas_Między_W_Sekundach().

//Funkcja Czas_Między_W_Milisekundach().
function Czas_Między_W_Milisekundach( const czas_poprzedni_f : Int64; const zmienna_w_milisekundach_f : boolean = false ) : Int64;
begin

  //
  // Funkcja wylicza ilość milisekund bezwzględnego czasu gry jaka upłynęła od podanego czasu do chwili obecnej.
  //
  // Zwraca ilość milisekund bezwzględnego czasu gry w postaci 123 (1:30 = 1 500).
  //
  // Parametry:
  //   czas_poprzedni_f - moment czasu gry, od którego liczyć upływ czasu.
  //   zmienna_w_milisekundach_f
  //     false - zmienna czas_poprzedni_f przechowuje wartość w sekundach (wartość zmiennej dla 1 sekunda = 1).
  //     true - zmienna czas_poprzedni_f przechowuje wartość w milisekundach (wartość zmiennej dla 1 sekunda = 1 000).
  //

  if not zmienna_w_milisekundach_f then
    Result := Round(  Abs( Animacja__BabyMetal__Kaelan_Mikla__Form.GLCadencer1.CurrentTime - czas_poprzedni_f ) * 1000  )
  else//if not zmienna_w_milisekundach_f then
    Result := Round(  Abs( Animacja__BabyMetal__Kaelan_Mikla__Form.GLCadencer1.CurrentTime * 1000 - czas_poprzedni_f )  );

end;//---//Funkcja Czas_Między_W_Milisekundach().

//Funkcja Czas_Teraz().
function Czas_Teraz() : double;
begin

  //
  // Funkcja zwraca aktualny bezwzględny czas gry.
  //  Ze względu na pauzowanie gdy nie można wyliczać na podstawie czasu systemowego.
  //
  // Zwraca aktualny bezwzględny czas gry w postaci 123.456 (1:30 = 1.5).
  //

  Result := Animacja__BabyMetal__Kaelan_Mikla__Form.GLCadencer1.CurrentTime;

end;//---//Funkcja Czas_Teraz().

//Funkcja Czas_Teraz_W_Sekundach().
function Czas_Teraz_W_Sekundach() : Int64;
begin

  //
  // Funkcja zwraca aktualny bezwzględny czas gry bez ułamków sekund.
  //
  // Zwraca aktualny bezwzględny czas gry bez ułamków sekund w postaci 123 (1:59 = 1).
  //

  Result := Floor( Czas_Teraz() );

end;//---//Funkcja Czas_Teraz_W_Sekundach().

//Funkcja Czas_Teraz_W_Milisekundach().
function Czas_Teraz_W_Milisekundach() : Int64;
begin

  //
  // Funkcja zwraca aktualny bezwzględny czas gry w milisekundach.
  //
  // Zwraca aktualny bezwzględny czas gry w milisekundach w postaci 123.456 (1:30 = 1 500).
  //

  Result := Round( Animacja__BabyMetal__Kaelan_Mikla__Form.GLCadencer1.CurrentTime * 1000 );

end;//---//Funkcja Czas_Teraz_W_Milisekundach().

//Funkcja Komunikat_Wyświetl().
function TAnimacja__BabyMetal__Kaelan_Mikla__Form.Komunikat_Wyświetl( const text_f, caption_f : string; const flags_f : integer ) : integer;
var
  czy_pauza_l,
  gl_user_interface__mouse_look_active
    : boolean;
begin

  czy_pauza_l := Czy_Pauza();
  gl_user_interface__mouse_look_active := GLUserInterface1.MouseLookActive;


  if not czy_pauza_l then
    Pauza();

  if GLUserInterface1.MouseLookActive then
    GLUserInterface1.MouseLookActive := false;


  Result := Application.MessageBox( PChar(text_f), PChar(caption_f), flags_f );


  if not czy_pauza_l then
    Pauza();

  if gl_user_interface__mouse_look_active then
    GLUserInterface1.MouseLookActive := true;

end;//---//Funkcja Komunikat_Wyświetl().

//Funkcja Kamera_Ruch().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Kamera_Ruch( delta_czasu_f : double );
const
  ruch_c_l : single = 5;
begin

  if IsKeyDown( 'W' ) then // uses GLKeyboard.
    Gra_GLCamera.Move( ruch_c_l * gra_współczynnik_prędkości_g * delta_czasu_f );

  if IsKeyDown( 'S' ) then
    Gra_GLCamera.Move( -ruch_c_l * gra_współczynnik_prędkości_g * delta_czasu_f );

  if IsKeyDown( 'A' ) then
    Gra_GLCamera.Slide( -ruch_c_l * gra_współczynnik_prędkości_g * delta_czasu_f );

  if IsKeyDown( 'D' ) then
    Gra_GLCamera.Slide( ruch_c_l * gra_współczynnik_prędkości_g * delta_czasu_f );


  if IsKeyDown( 'R' ) then // Góra.
    Gra_GLCamera.Lift( ruch_c_l * gra_współczynnik_prędkości_g * delta_czasu_f );

  if IsKeyDown( 'F' ) then // Dół.
    Gra_GLCamera.Lift( -ruch_c_l * gra_współczynnik_prędkości_g * delta_czasu_f );


  if IsKeyDown( 'Q' ) then // Obrót w lewo.
    Gra_GLCamera.Turn( -ruch_c_l * gra_współczynnik_prędkości_g * delta_czasu_f * 10 );

  if IsKeyDown( 'E' ) then // Obrót w prawo.
    Gra_GLCamera.Turn( ruch_c_l * gra_współczynnik_prędkości_g * delta_czasu_f * 10 );

end;//---//Funkcja Kamera_Ruch().

//Funkcja Czy_Pauza().
function TAnimacja__BabyMetal__Kaelan_Mikla__Form.Czy_Pauza() : boolean;
begin

  //
  // Funkcja sprawdza czy jest aktywna pauza.
  //
  // Zwraca prawdę gdy jest aktywna pauza.
  //

  Result := not GLCadencer1.Enabled;

end;//---//Funkcja Czy_Pauza().

//Funkcja Pauza().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Pauza();
begin

  // Pauza podczas wyłączania przeskakuje widokiem kamery gdy obracanie myszą jest włączone.

  GLCadencer1.Enabled := not GLCadencer1.Enabled;

  if GLCadencer1.Enabled then
    begin

      // Nie pauza.

      GLCadencer1.TimeMultiplier := gra_współczynnik_prędkości_g; // Jeżeli zmienia się GLCadencer1.TimeMultiplier podczas pauzy to po wyłączeniu pauzy następuje skok w przeliczaniu.
      Pauza_Button.Font.Style := [];

    end
  else//if GLCadencer1.Enabled then
    begin

      // Pauza.

      Pauza_Button.Font.Style := [ fsBold ];

    end;
  //---//if GLCadencer1.Enabled then

end;//---//Funkcja Pauza().

//Funkcja Gra_Współczynnik_Prędkości_Zmień().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Gra_Współczynnik_Prędkości_Zmień( const zmiana_kierunek_f : smallint );
var
  i,
  zti
    : integer;
  ztc,
  skok
    : currency; // Nie działa dla real, double, działa dla currency, variant.
  zts : string;
begin

  //
  // Funkcja zmienia prędkość gry.
  //
  // Parametry:
  //   zmiana_kierunek_f:
  //     -1 - spowalnia.
  //     0 - normalna prędkość gry.
  //     1 - przyśpiesza.
  //

  if zmiana_kierunek_f = 0 then
    gra_współczynnik_prędkości_g := 1
  else//if zmiana_kierunek_f = 0 then
    begin

      // Wariant statyczny dla przedziałów: 0.01 - 0.1 - 1
      //if   (
      //           ( gra_współczynnik_prędkości_g = 0.1 )
      //       and ( zmiana_kierunek_f < 0 )
      //     )
      //  or ( gra_współczynnik_prędkości_g < 0.1 ) then
      //  skok := 0.01
      //else//if   ( (...)
      //if   (
      //           ( gra_współczynnik_prędkości_g = 1 )
      //       and ( zmiana_kierunek_f < 0 )
      //     )
      //  or ( gra_współczynnik_prędkości_g < 1 ) then
      //  skok := 0.1
      //else//if   ( (...)
      //  skok := 1;


      // Wariant dostosowujący zmianę wielkości skoku prędkości gry zależnie od rzędu wielkości aktualnej prędkości gry (0.0001 - -900000000000000).
      if gra_współczynnik_prędkości_g >= 1 then
        begin

          zts := FloatToStr(  Trunc( gra_współczynnik_prędkości_g )  );
          zti := Length( zts );

          zts := '1';

          for i := 1 to zti - 1 do
            zts := zts + '0';

          skok := StrToCurr( zts );

          if    ( gra_współczynnik_prędkości_g = skok )
            and ( zmiana_kierunek_f < 0 ) then
            skok := skok * 0.1
          else//if    ( gra_współczynnik_prędkości_g = skok ) (...)
            skok := StrToCurr( zts );

        end
      else//if gra_współczynnik_prędkości_g >= 1 then
        begin

          zts := FloatToStr(  Frac( gra_współczynnik_prędkości_g )  );
          zti := Length( zts ) - 2; // 2 = '0.'.

          zts := '';

          for i := 1 to zti - 1 do
            zts := zts + '0';

          zts := '0,' + zts + '1';

          skok := StrToCurr( zts );

          if    ( gra_współczynnik_prędkości_g = skok )
            and ( zmiana_kierunek_f < 0 ) then
            skok := skok * 0.1 // Po operacji 0,0001 * 0.1 zmienna currency daje wynik 0.
          else//if    ( gra_współczynnik_prędkości_g = skok ) (...)
            skok := StrToCurr( zts );

        end;
      //---//if gra_współczynnik_prędkości_g >= 1 then


      if zmiana_kierunek_f < 0 then
        skok := -skok;


      if zmiana_kierunek_f > 0 then
        ztc := gra_współczynnik_prędkości_g;

      gra_współczynnik_prędkości_g := gra_współczynnik_prędkości_g + skok;

      if    ( zmiana_kierunek_f > 0 )
        and ( gra_współczynnik_prędkości_g < ztc ) then // Zabezpiecza aby po osiągnięciu maksymalnego zakresu zmiennej jej wartość nie przeskoczyła na minimalny zakres zmiennej (900000000000000).
        gra_współczynnik_prędkości_g := ztc;

    end;
  //---//if zmiana_kierunek_f = 0 then


  if gra_współczynnik_prędkości_g <= 0 then
    gra_współczynnik_prędkości_g := 0.0001;


  if not Czy_Pauza() then // Jeżeli zmienia się GLCadencer1.TimeMultiplier podczas pauzy to po wyłączeniu pauzy następuje skok w przeliczaniu.
    GLCadencer1.TimeMultiplier := gra_współczynnik_prędkości_g; // 0 - zatrzymany, (0..1) - spowalnia, 1 - prędkość normalna gry, 1 > - przyśpiesza.


  Gra_Współczynnik_Prędkości_Label.Caption := FloatToStr( gra_współczynnik_prędkości_g );


  Informacja_Ekranowa_Wyświetl( 'Prędkość gry ' + Gra_Współczynnik_Prędkości_Label.Caption );

end;//---//Funkcja Gra_Współczynnik_Prędkości_Zmień().

//Funkcja Informacja_Ekranowa_Wyświetl().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Informacja_Ekranowa_Wyświetl( const napis_f : string );
begin

  if not Informacja_Ekranowa_CheckBox.Checked then
    Exit;


  //Informacja_Ekranowa_GLAsyncTimer.Enabled := false;
  Informacja_Ekranowa_Timer.Enabled := false; // Lepiej działa.

  Informacja_Ekranowa_GLHUDText.Text := '   ' + napis_f;

  Gra_GLWindowsBitmapFont.EnsureString( Informacja_Ekranowa_GLHUDText.Text );
  Application.ProcessMessages(); // Chyba pomaga na błąd 'Range check error'.

  try
    Informacja_Ekranowa_GLHUDSprite.Width := Gra_GLWindowsBitmapFont.TextWidth( Informacja_Ekranowa_GLHUDText.Text ) + 15; // Gdy jest znak lokalny to za pierwszym razem zgłasza błąd 'Range check error'.
  except
    Informacja_Ekranowa_GLHUDSprite.Width := Gra_GLSceneViewer.Width * 0.25;

    if Informacja_Ekranowa_GLHUDSprite.Width < 160 then
      Informacja_Ekranowa_GLHUDSprite.Width := 160;
  end;
  //---//try

  Informacja_Ekranowa_GLHUDSprite.Position.X := Informacja_Ekranowa_GLHUDSprite.Width * 0.5;

  Informacja_Ekranowa_GLHUDSprite.Visible := true;
  Informacja_Ekranowa_GLHUDText.Visible := true;

  Application.ProcessMessages();

  //Informacja_Ekranowa_GLAsyncTimer.Enabled := true;
  Informacja_Ekranowa_Timer.Enabled := true;

end;//---//Funkcja Informacja_Ekranowa_Wyświetl().

//Funkcja Animacja_Etap_Informacja().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Animacja_Etap_Informacja();
begin

  Animacja_Etap_Label.Caption := GetEnumName(  TypeInfo(TAnimacja_Etap), Ord( animacja__etap_g )  ); // uses  System.TypInfo. // Daje nazwy elementów.
  Animacja_Etap_Label.Caption := StringReplace( Animacja_Etap_Label.Caption, 'ae_', '', [ rfReplaceAll ] );
  Animacja_Etap_Label.Caption := StringReplace( Animacja_Etap_Label.Caption, '_', ' ', [ rfReplaceAll ] );

end;//---//Funkcja Animacja_Etap_Informacja().

//Funkcja Animacja_Parametry_Początkowe_Ustaw().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Animacja_Parametry_Początkowe_Ustaw();
var
  i : integer;
  ztdt : TDateTime;
begin

  if   ( schemat_elementy_list = nil )
    or (  not Assigned( schemat_elementy_list )  )
    or ( śnieg_efekt_list = nil )
    or (  not Assigned( śnieg_efekt_list )  ) then
    Exit;


  ProgressBar1.Position := 0;
  ProgressBar2.Position := 0;
  ProgressBar1.Max := schemat_elementy_list.Count + śnieg_efekt_list.Count;

  ProgressBar1__Widoczność_Ustaw();


  ztdt := Now();


  for i := 0 to śnieg_efekt_list.Count - 1 do
    begin

      TŚnieg_Efekt(śnieg_efekt_list[ i ]).Animacja_Parametry_Początkowe_Ustaw();

      ProgressBar1.StepIt();

      //if i mod 10 = 0 then
      //  Application.ProcessMessages();
      if MilliSecondsBetween( Now(), ztdt ) >= postęp_odświeżanie_milisekundy_c then
        begin

          ProgressBar1__Widoczność_Ustaw();

          Application.ProcessMessages();

          ztdt := Now();

        end;
      //---//if MilliSecondsBetween( Now(), ztdt ) >= postęp_odświeżanie_milisekundy_c then

    end;
  //---//for i := 0 to śnieg_efekt_list.Count - 1 do


  for i := 0 to schemat_elementy_list.Count - 1 do
    begin

      TSchemat_Element(schemat_elementy_list[ i ]).Animacja_Parametry_Początkowe_Ustaw();

      ProgressBar1.StepIt();

      //if i mod 100 = 0 then
      //  Application.ProcessMessages();
      if MilliSecondsBetween( Now(), ztdt ) >= postęp_odświeżanie_milisekundy_c then
        begin

          ProgressBar1__Widoczność_Ustaw();

          Application.ProcessMessages();

          ztdt := Now();

        end;
      //---//if MilliSecondsBetween( Now(), ztdt ) >= postęp_odświeżanie_milisekundy_c then

    end;
  //---//for i := 0 to schemat_elementy_list.Count - 1 do


  animacja__etap_g := ae_Schemat_Przygotowany;
  //animacja__etap__czas_zmiany_ostatniej_g := Now();
  animacja__etap__czas_milisekundy_i := Czas_Teraz_W_Milisekundach();
  falowanie__kolumna_poprzednia__falowanie_rozpoczęcie_czas_milisekundy_i := 0;
  falowanie__kolumny_wszystkie_falują_g := false;
  Animacja_Etap_Informacja();


  ProgressBar1__Widoczność_Ustaw( false );

end;//---//Funkcja Animacja_Parametry_Początkowe_Ustaw().

//Funkcja Animuj().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Animuj( const delta_czasu_f : double );
var
  czy_była_zmiana : boolean;
  i : integer;
begin

  if   ( schemat_elementy_list = nil )
    or (  not Assigned( schemat_elementy_list )  ) then
    Exit;


  if animacja__etap_g <> ae_Schemat_Animowany then
    begin

      animacja__etap_g := ae_Schemat_Animowany;
      //animacja__etap__czas_zmiany_ostatniej_g := Now();
      animacja__etap__czas_milisekundy_i := Czas_Teraz_W_Milisekundach();
      Animacja_Etap_Informacja();

    end;
  //---//if animacja__etap_g <> ae_Schemat_Animowany then


  czy_była_zmiana := false;


  for i := 0 to schemat_elementy_list.Count - 1 do
    if  TSchemat_Element(schemat_elementy_list[ i ]).animacja__element_etap = aee_Element_Animowany then
      begin

        if TSchemat_Element(schemat_elementy_list[ i ]).animacja__rodzaj__se = ar_BabyMetal then
          begin

            if TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha > 0 then
              begin

                TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha := TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha
                  - schemat_ustawienia_r_g.animacja__szybkość_zmiany_przeźroczystości * delta_czasu_f;

                czy_była_zmiana := true;

              end;
            //---//if TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha > 0 then


            if TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha < 0 then
              TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha := 0;

            if TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha <= 0 then
              begin

                TSchemat_Element(schemat_elementy_list[ i ]).animacja__element_etap := aee_Animacja_Zakończona;
                TSchemat_Element(schemat_elementy_list[ i ]).efekt_gl_fire_fx_manager.Disabled := true;

              end;
            //---//if TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha <= 0 then

          end
        else//if TSchemat_Element(schemat_elementy_list[ i ]).animacja__rodzaj__se = ar_BabyMetal then
        if TSchemat_Element(schemat_elementy_list[ i ]).animacja__rodzaj__se = ar_Kælan_Mikla then
          begin

            if TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha < 1 then
              begin

                TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha := TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha
                  + schemat_ustawienia_r_g.animacja__szybkość_zmiany_przeźroczystości * delta_czasu_f;

                czy_była_zmiana := true;

              end;
            //---//if TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha < 1 then


            if TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha > 1 then
              TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha := 1;

            if TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha >= 1 then
              begin

                TSchemat_Element(schemat_elementy_list[ i ]).animacja__element_etap := aee_Animacja_Zakończona;
                TSchemat_Element(schemat_elementy_list[ i ]).efekt_gl_fire_fx_manager.Disabled := true;

                Rozbłyski__Losowanie_Element_Indeks_Dodaj( i );

              end;
            //---//if TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Material.FrontProperties.Diffuse.Alpha >= 1 then

          end;
        //---//if TSchemat_Element(schemat_elementy_list[ i ]).animacja__rodzaj__se = ar_Kælan_Mikla then

      end;
    //---//if  TSchemat_Element(schemat_elementy_list[ i ]).animacja__element_etap = aee_Element_Animowany then


  if    ( animacja__krokowa_g )
    and ( not czy_była_zmiana )
    and ( animacja__krok__aktualny_g < animacja__krok__ostatni_g )
    and (  Length( schemat_elementy_losowanie_t ) <= 0  ) then
    begin

      if animacja__krok_czas_milisekundy_i = 0 then
        animacja__krok_czas_milisekundy_i := Czas_Teraz_W_Milisekundach()
      else//if animacja__krok_czas_milisekundy_i = 0 then
        if Czas_Między_W_Milisekundach( animacja__krok_czas_milisekundy_i, true ) > schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_kolejnego_kroku_milisekundy then
          begin

            inc( animacja__krok__aktualny_g );
            Schemat__Losowanie_Przygotuj();

            animacja__krok_czas_milisekundy_i := 0;

          end;
        //---//if Czas_Między_W_Milisekundach( animacja__krok_czas_milisekundy_i, true ) > schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_kolejnego_kroku_milisekundy then

    end;
  //---//if    ( animacja__krokowa_g ) (...)


  if    ( not czy_była_zmiana )
    and (
             ( not animacja__krokowa_g )
          or (
                   ( animacja__krokowa_g )
               and ( animacja__krok__aktualny_g >= animacja__krok__ostatni_g )
             )
        )
    and (  Length( schemat_elementy_losowanie_t ) <= 0  ) then
    begin

      Animacja_Zakończona_Label.Visible := true;

      animacja__etap_g := ae_Animacja_Zakończona;
      //animacja__etap__czas_zmiany_ostatniej_g := Now();
      animacja__etap__czas_milisekundy_i := Czas_Teraz_W_Milisekundach();
      Animacja_Etap_Informacja();

      Informacja_Ekranowa_Wyświetl( 'Animacja zakończona' );

    end;
  //---//if    ( not czy_była_zmiana ) (...)

end;//---//Funkcja Animuj().

//Funkcja Falowanie().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Falowanie( const delta_czasu_f : double );
var
  i,
  falowanie__kolumna_pierwsza_nieaktywna
    : integer;
begin

  //
  // Funkcja faluje elementami animacji.
  //

  if   ( schemat_elementy_list = nil )
    or (  not Assigned( schemat_elementy_list )  ) then
    Exit;


  if Czas_Między_W_Milisekundach( falowanie__kolumna_poprzednia__falowanie_rozpoczęcie_czas_milisekundy_i, true ) > schemat_ustawienia_r_g.falowanie__kolumna_następna__oczekiwanie__milisekundy then
    falowanie__kolumna_pierwsza_nieaktywna := -1
  else//if Czas_Między_W_Milisekundach( falowanie__kolumna_poprzednia__falowanie_rozpoczęcie_czas_milisekundy_i, true ) > schemat_ustawienia_r_g.falowanie__kolumna_następna__oczekiwanie__milisekundy then
    falowanie__kolumna_pierwsza_nieaktywna := -2;


  // Wylicza początkowe wartości.
  if delta_czasu_f = 0 then
    begin

      falowanie__kolumna_poprzednia__falowanie_rozpoczęcie_czas_milisekundy_i := 0;
      falowanie__kolumny_wszystkie_falują_g := false;

    end
  else//if delta_czasu_f = 0 then
    begin

      if    ( falowanie__kolumna_pierwsza_nieaktywna = -1 )
        and ( not falowanie__kolumny_wszystkie_falują_g ) then
        for i := 0 to schemat_elementy_list.Count - 1 do
          begin

            if    ( not TSchemat_Element(schemat_elementy_list[ i ]).falowanie__aktywne )
              and (
                       ( falowanie__kolumna_pierwsza_nieaktywna > TSchemat_Element(schemat_elementy_list[ i ]).kolumna )
                    or ( falowanie__kolumna_pierwsza_nieaktywna = -1 )
                  ) then
              falowanie__kolumna_pierwsza_nieaktywna := TSchemat_Element(schemat_elementy_list[ i ]).kolumna;

          end;
        //---//for i := 0 to schemat_elementy_list.Count - 1 do

    end;
  //---//if delta_czasu_f = 0 then
  //---// Wylicza początkowe wartości.


  for i := 0 to schemat_elementy_list.Count - 1 do
    begin

      if delta_czasu_f = 0 then
        begin

          TSchemat_Element(schemat_elementy_list[ i ]).falowanie__aktywne := false;
          TSchemat_Element(schemat_elementy_list[ i ]).falowanie__przesunięcie := 0;
          TSchemat_Element(schemat_elementy_list[ i ]).Position.Z := 0;

          TSchemat_Element(schemat_elementy_list[ i ]).efekt_gl_dummy_cube.Position.Z := TSchemat_Element(schemat_elementy_list[ i ]).Position.Z
            + TSchemat_Element(schemat_elementy_list[ i ]).efekt_gl_dummy_cube__position__z__kopia;

        end
      else//if delta_czasu_f = 0 then
        begin

          if    ( not TSchemat_Element(schemat_elementy_list[ i ]).falowanie__aktywne )
            and ( TSchemat_Element(schemat_elementy_list[ i ]).kolumna = falowanie__kolumna_pierwsza_nieaktywna ) then
            TSchemat_Element(schemat_elementy_list[ i ]).falowanie__aktywne := true;


          if TSchemat_Element(schemat_elementy_list[ i ]).falowanie__aktywne then
            begin

              TSchemat_Element(schemat_elementy_list[ i ]).falowanie__przesunięcie := TSchemat_Element(schemat_elementy_list[ i ]).falowanie__przesunięcie +
                schemat_ustawienia_r_g.falowanie__szybkość * delta_czasu_f;

              if TSchemat_Element(schemat_elementy_list[ i ]).falowanie__przesunięcie >= Pi * 2 then
                TSchemat_Element(schemat_elementy_list[ i ]).falowanie__przesunięcie := 0;

              TSchemat_Element(schemat_elementy_list[ i ]).Position.Z := Sin( TSchemat_Element(schemat_elementy_list[ i ]).falowanie__przesunięcie ) * schemat_ustawienia_r_g.falowanie__amplituda;

              TSchemat_Element(schemat_elementy_list[ i ]).efekt_gl_dummy_cube.Position.Z := TSchemat_Element(schemat_elementy_list[ i ]).Position.Z
                + TSchemat_Element(schemat_elementy_list[ i ]).efekt_gl_dummy_cube__position__z__kopia;

            end;
          //---//if TSchemat_Element(schemat_elementy_list[ i ]).falowanie__aktywne then

        end;
      //---//if delta_czasu_f = 0 then

    end;
  //---//for i := 0 to schemat_elementy_list.Count - 1 do


  if falowanie__kolumna_pierwsza_nieaktywna = -1 then
    begin

      if    ( delta_czasu_f <> 0 )
        and ( not falowanie__kolumny_wszystkie_falują_g ) then
        falowanie__kolumny_wszystkie_falują_g := true;

    end
  else//if falowanie__kolumna_pierwsza_nieaktywna = -1 then
    begin

      if falowanie__kolumny_wszystkie_falują_g then
        falowanie__kolumny_wszystkie_falują_g := false; // Tutaj raczej nie wejdzie.

    end;
  //---//if falowanie__kolumna_pierwsza_nieaktywna = -1 then


  if falowanie__kolumna_pierwsza_nieaktywna > 0 then
    falowanie__kolumna_poprzednia__falowanie_rozpoczęcie_czas_milisekundy_i := Czas_Teraz_W_Milisekundach()

end;//---//Funkcja Falowanie().

//Funkcja ProgressBar1__Widoczność_Ustaw().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.ProgressBar1__Widoczność_Ustaw( const widoczny_f : boolean = true );
begin

  //
  // Funkcja ustawia widoczność głównego paska postępu.
  // Na pełnym ekranie nie widać paska postępu gdy nie jest widoczny jakiś element więc po to jest ProgressBar1__Widoczność_Splitter.
  //
  // Parametry:
  //   widoczny_f
  //

  if ProgressBar1.Parent <> Opcje_TabSheet then
    begin

      if ProgressBar1.Visible <> widoczny_f then
        ProgressBar1.Visible := widoczny_f;

      if ProgressBar1__Widoczność_Splitter.Visible <> widoczny_f then
        ProgressBar1__Widoczność_Splitter.Visible := widoczny_f;

    end
  else//if ProgressBar1.Parent <> Opcje_TabSheet then
    if ProgressBar1__Widoczność_Splitter.Visible then
      ProgressBar1__Widoczność_Splitter.Visible := false;

end;//---//Funkcja ProgressBar1__Widoczność_Ustaw().

//Funkcja Rozbłyski__Losowanie_Element_Indeks_Dodaj().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Rozbłyski__Losowanie_Element_Indeks_Dodaj( const element_indeks_f : integer );
var
  zti : integer;
begin

  //
  // Funkcja dodaje indeks, który można wylosować dla efektów rozbłysku.
  //

  if   ( schemat_ustawienia_r_g.animacja__rodzaj_su <> ar_Kælan_Mikla )
    or ( losowanie__rozbłysku__kolejne__zakres__czas_milisekundy_i < 0 ) then
    Exit;


  zti := Length( rozbłyski_losowanie_t );
  SetLength( rozbłyski_losowanie_t, zti + 1 );
  rozbłyski_losowanie_t[ zti ] := element_indeks_f;

end;//---//Funkcja Rozbłyski__Losowanie_Element_Indeks_Dodaj().

//Funkcja Rozbłyski__Losowanie_Przygotuj().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Rozbłyski__Losowanie_Przygotuj();
begin

  //
  // Funkcja przygotowuje dane potrzebne do losowania elementów w trakcie animacji.
  //

  SetLength( rozbłyski_losowanie_t, 0 );

end;//---//Funkcja Rozbłyski__Losowanie_Element_Indeks_Dodaj().

//Funkcja Rozbłyski__Losuj().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Rozbłyski__Losuj();
var
  zti : integer;
begin

  //
  // Funkcja losuje elementy, które wyświetlą efekt rozbłysku.
  //

  if   ( schemat_ustawienia_r_g.animacja__rodzaj_su <> ar_Kælan_Mikla )
    or ( losowanie__rozbłysku__kolejne__zakres__czas_milisekundy_i < 0 ) // Po ponownym wczytaniu ustawień z pliku ini tabela może być niepusta a wartość wskazywać na wyłączenie rozbłysków.
    or ( schemat_elementy_list = nil )
    or (  not Assigned( schemat_elementy_list )  )
    or (  Length( rozbłyski_losowanie_t ) <= 0  )
    or (  Czas_Między_W_Milisekundach( losowanie__rozbłysku__ostatnie_czas_milisekundy_i, true ) < losowanie__rozbłysku__kolejne__losowy__czas_milisekundy_i  ) then
    Exit;


  zti := Length( rozbłyski_losowanie_t );
  zti := Random( zti );

  if    ( rozbłyski_losowanie_t[ zti ] >= 0 )
    and ( rozbłyski_losowanie_t[ zti ] < schemat_elementy_list.Count )
    and ( TSchemat_Element(schemat_elementy_list[  rozbłyski_losowanie_t[ zti ]  ]).animacja__element_etap = aee_Animacja_Zakończona ) then
    begin

      TSchemat_Element(schemat_elementy_list[  rozbłyski_losowanie_t[ zti ]  ]).efekt_gl_fire_fx_manager.IsotropicExplosion
        (
          schemat_ustawienia_r_g.śnieg__rozbłysk__min_initial_speed,
          schemat_ustawienia_r_g.śnieg__rozbłysk__max_initial_speed,
          schemat_ustawienia_r_g.śnieg__rozbłysk__life_boost_factor,
          schemat_ustawienia_r_g.śnieg__rozbłysk__nb_particles
        );

    end;
  //---//if    ( rozbłyski_losowanie_t[ zti ] >= 0 ) (...)


  losowanie__rozbłysku__kolejne__losowy__czas_milisekundy_i := Random( losowanie__rozbłysku__kolejne__zakres__czas_milisekundy_i + 1 );

  losowanie__rozbłysku__ostatnie_czas_milisekundy_i := Czas_Teraz_W_Milisekundach();

end;//---//Funkcja Rozbłyski__Losuj().

//Funkcja Schemat__Kamera_Ustaw().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Schemat__Kamera_Ustaw();
var
  i : integer;
  skala_kopia, // Do ustalenia marginesów obrazu na około schematu.
  x__min, // Lewo.
  x__max, // Prawo.
  y__min, // Dół.
  y__max // Góra.
    : single;
  kursor_kopia : TCursor; // Ta funkcja może zostać wywołana w trakcie trwania jakiejś 'długiej' operacji.
  zt_affine_vector_1,
  zt_affine_vector_2
    : TAffineVector;
begin

  //
  // Funkcja próbuje ustawić kamerę tak aby było widać cały schemat.
  //

  // Nie trzeba korygować o skalę.

  if   ( schemat_elementy_list = nil )
    or (  not Assigned( schemat_elementy_list )  ) then
    Exit;


  kursor_kopia := Screen.Cursor;
  Screen.Cursor := crHourGlass;


  skala_kopia := 1;
  x__min := 0;
  x__max := 0;
  y__min := 0;
  y__max := 0;


  Gra_GLCamera.ResetRotations();
  Gra_GLCamera.Direction.Z := -1;


  for i := 0 to schemat_elementy_list.Count - 1 do
    begin

      if i = 0 then
        begin

          skala_kopia := TSchemat_Element(schemat_elementy_list[ i ]).element_gl_cube.Scale.X;
          x__min := TSchemat_Element(schemat_elementy_list[ i ]).Position.X;
          x__max := TSchemat_Element(schemat_elementy_list[ i ]).Position.X;
          y__min := TSchemat_Element(schemat_elementy_list[ i ]).Position.Y;
          y__max := TSchemat_Element(schemat_elementy_list[ i ]).Position.Y;

        end
      else//if i = 0 then
        begin

          if x__min > TSchemat_Element(schemat_elementy_list[ i ]).Position.X then
            x__min := TSchemat_Element(schemat_elementy_list[ i ]).Position.X;

          if x__max < TSchemat_Element(schemat_elementy_list[ i ]).Position.X then
            x__max := TSchemat_Element(schemat_elementy_list[ i ]).Position.X;

          if y__min > TSchemat_Element(schemat_elementy_list[ i ]).Position.Y then
            y__min := TSchemat_Element(schemat_elementy_list[ i ]).Position.Y;

          if y__max < TSchemat_Element(schemat_elementy_list[ i ]).Position.Y then
            y__max := TSchemat_Element(schemat_elementy_list[ i ]).Position.Y;

        end;
      //---//if i = 0 then

    end;
  //---//for i := 0 to schemat_elementy_list.Count - 1 do


  Gra_GLCamera.Position.SetPoint(  ( x__min + x__max ) * 0.5, ( y__min + y__max ) * 0.5, 0 );


  x__min := x__min - skala_kopia * 2;
  x__max := x__max + skala_kopia * 2;
  y__min := y__min - skala_kopia * 2;
  y__max := y__max + skala_kopia * 2;


  zt_affine_vector_1 := Gra_GLSceneViewer.Buffer.WorldToScreen(  GLVectorGeometry.AffineVectorMake( x__min, y__min, 0 )  );
  zt_affine_vector_2 := Gra_GLSceneViewer.Buffer.WorldToScreen(  GLVectorGeometry.AffineVectorMake( x__max, y__max, 0 )  );

  while ( zt_affine_vector_1.X < 0 )
     or ( zt_affine_vector_1.Y < 0 )
     or ( zt_affine_vector_1.X > Gra_GLSceneViewer.Width )
     or ( zt_affine_vector_1.Y > Gra_GLSceneViewer.Height )
     or ( zt_affine_vector_2.X < 0 )
     or ( zt_affine_vector_2.Y < 0 )
     or ( zt_affine_vector_2.X > Gra_GLSceneViewer.Width )
     or ( zt_affine_vector_2.Y > Gra_GLSceneViewer.Height ) do
    begin

      Gra_GLCamera.Position.Z := Gra_GLCamera.Position.Z + 1 * skala_kopia;

      zt_affine_vector_1 := Gra_GLSceneViewer.Buffer.WorldToScreen(  GLVectorGeometry.AffineVectorMake( x__min, y__min, 0 )  );
      zt_affine_vector_2 := Gra_GLSceneViewer.Buffer.WorldToScreen(  GLVectorGeometry.AffineVectorMake( x__max, y__max, 0 )  );

    end;
  //---//while ( zt_affine_vector_1.X < 0 ) (...)


  Gra_GLCamera.Position.Z := Gra_GLCamera.Position.Z + Gra_GLCamera.Position.Z * 0.1;

  //Gra_GLLightSource.Position.X := Gra_GLCamera.Position.X;
  //Gra_GLLightSource.Position.Y := Gra_GLCamera.Position.Y;
  Gra_GLLightSource.Position := Gra_GLCamera.Position;
  Gra_GLLightSource.Position.Z := Gra_GLLightSource.Position.Z + 100;

  X_Y_Min_Max_Label.Hint :=
    'x min: ' + Trim(  FormatFloat( '### ### ##0.000', x__min )  ) + ';' + #13 +
    'x max: ' + Trim(  FormatFloat( '### ### ##0.000', x__max )  ) + ';' + #13 +
    'y min: ' + Trim(  FormatFloat( '### ### ##0.000', y__min )  ) + ';' + #13 +
    'y max: ' + Trim(  FormatFloat( '### ### ##0.000', y__max )  ) + '.';

  //Screen.Cursor := crDefault;
  Screen.Cursor := kursor_kopia;

end;//---//Funkcja Schemat__Kamera_Ustaw().

//Funkcja Schemat__Lista_Wczytaj().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Schemat__Lista_Wczytaj();
var
  i : integer;
  zts,
  tłumaczenie_nazwa_kopia_l
    : string;
  search_rec : TSearchRec;
begin

  tłumaczenie_nazwa_kopia_l := Schematy_ComboBox.Text;
  Schematy_ComboBox.Items.Clear();

  // Jeżeli znajdzie plik zwraca 0, jeżeli nie znajdzie zwraca numer błędu. Na początku znajduje '.' '..' potem listę plików.
  if FindFirst(  ExtractFilePath( Application.ExeName ) + schematy_katalog_nazwa_c + '\*.txt', faAnyFile, search_rec  ) = 0 then // Application potrzebuje w uses Forms.
    begin

      repeat

        // Dodaje nazwy plików bez rozszerzenia.

        zts := search_rec.Name;
        zts := ReverseString( zts ); //uses StrUtils.
        Delete(  zts, 1, Pos( '.', zts )  );
        zts := ReverseString( zts ); //uses StrUtils.

        Schematy_ComboBox.Items.Add( zts );

      until FindNext( search_rec ) <> 0

    end;
  //---//if FindFirst(  ExtractFilePath( Application.ExeName ) + schematy_katalog_nazwa_c'\*.txt', faAnyFile, search_rec  ) = 0 then

  FindClose( search_rec );

  if Trim( tłumaczenie_nazwa_kopia_l ) <> '' then
    for i := Schematy_ComboBox.Items.Count - 1 downto 0 do
      if Schematy_ComboBox.Items[ i ] = tłumaczenie_nazwa_kopia_l then
        begin

          Schematy_ComboBox.ItemIndex := i;
          Break;

        end;
      //---//if Schematy_ComboBox.Items[ i ] = tłumaczenie_nazwa_kopia_l then


  if    ( Schematy_ComboBox.ItemIndex < 0 )
    and ( Schematy_ComboBox.Items.Count > 0 ) then
    Schematy_ComboBox.ItemIndex := 0;

end;//---//Funkcja Schemat__Lista_Wczytaj().

//Funkcja Schemat__Losowanie_Przygotuj().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Schemat__Losowanie_Przygotuj();
var
  i,
  zti
    : integer;
begin

  //
  // Funkcja przygotowuje dane potrzebne do losowania elementów w trakcie animacji.
  //

  if   ( schemat_elementy_list = nil )
    or (  not Assigned( schemat_elementy_list )  ) then
    Exit;


  SetLength( schemat_elementy_losowanie_t, 0 );

  for i := 0 to schemat_elementy_list.Count - 1 do
    if TSchemat_Element(schemat_elementy_list[ i ]).animacja__krok = animacja__krok__aktualny_g then
      begin

        zti := Length( schemat_elementy_losowanie_t );
        SetLength( schemat_elementy_losowanie_t, zti + 1 );
        schemat_elementy_losowanie_t[ zti ] := i;

      end;
    //---//if TSchemat_Element(schemat_elementy_list[ i ]).animacja__krok = animacja__krok__aktualny_g then

end;//---//Funkcja Schemat__Losowanie_Przygotuj().

//Funkcja Schemat__Losuj().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Schemat__Losuj();
var
  i,
  j,
  k,
  l,
  zti,
  kolumna_kopia,
  wiersz_kopia,
  losowania_ilość
    : integer;
begin

  //
  // Funkcja losuje elementy, które będą animowane.
  //

  if   ( schemat_elementy_list = nil )
    or (  not Assigned( schemat_elementy_list )  )
    or (  Length( schemat_elementy_losowanie_t ) <= 0  )
    or (  Czas_Między_W_Milisekundach( losowanie__elementu__ostatnie_czas_milisekundy_i, true ) < losowanie__elementu__kolejne__losowy__czas_milisekundy_i  ) then
    Exit;


  if schemat_ustawienia_r_g.losowanie__elementu__ilość_jednocześnie > 0 then
    losowania_ilość := schemat_ustawienia_r_g.losowanie__elementu__ilość_jednocześnie
  else//if schemat_ustawienia_r_g.losowanie__elementu__ilość_jednocześnie > 0 then
    begin

      //zti := Round( schemat_elementy_list.Count * 0.1 );
      //
      //if zti < 1 then
      //  zti := 1;
      //
      //losowania_ilość := Round( schemat_elementy_list.Count / zti );

      losowania_ilość := Round( schemat_elementy_list.Count * 0.01 );

      if losowania_ilość < 1 then
        losowania_ilość := 1;

    end;
  //---//if schemat_ustawienia_r_g.losowanie__elementu__ilość_jednocześnie > 0 then


  if losowania_ilość < 1 then
    losowania_ilość := 1;

  for i := 1 to losowania_ilość do
    begin

      zti := Length( schemat_elementy_losowanie_t );
      zti := Random( zti );

      if    ( schemat_elementy_losowanie_t[ zti ] >= 0 )
        and ( schemat_elementy_losowanie_t[ zti ] < schemat_elementy_list.Count )
        and ( TSchemat_Element(schemat_elementy_list[  schemat_elementy_losowanie_t[ zti ]  ]).animacja__element_etap <> aee_Animacja_Zakończona ) then
        begin

          TSchemat_Element(schemat_elementy_list[  schemat_elementy_losowanie_t[ zti ]  ]).animacja__element_etap := aee_Element_Animowany;

          if TSchemat_Element(schemat_elementy_list[  schemat_elementy_losowanie_t[ zti ]  ]).animacja__rodzaj__se = ar_BabyMetal then
            TSchemat_Element(schemat_elementy_list[  schemat_elementy_losowanie_t[ zti ]  ]).efekt_gl_fire_fx_manager.Disabled := false;


          if schemat_ustawienia_r_g.animacja__promień > 0 then
            begin

              kolumna_kopia := TSchemat_Element(schemat_elementy_list[  schemat_elementy_losowanie_t[ zti ]  ]).kolumna;
              wiersz_kopia := TSchemat_Element(schemat_elementy_list[  schemat_elementy_losowanie_t[ zti ]  ]).wiersz;

            end;
          //---//if schemat_ustawienia_r_g.animacja__promień > 0 then

        end;
      //---//if    ( schemat_elementy_losowanie_t[ zti ] >= 0 ) (...)


      // Usuwanie wylosowanego elementu z tabeli.
      for j := zti to Length( schemat_elementy_losowanie_t ) - 2 do
        schemat_elementy_losowanie_t[ j ] := schemat_elementy_losowanie_t[ j + 1 ];

      if Length( schemat_elementy_losowanie_t ) >= 1 then
        SetLength(  schemat_elementy_losowanie_t, Length( schemat_elementy_losowanie_t ) - 1  );


      if schemat_ustawienia_r_g.animacja__promień > 0 then
        for k := 0 to schemat_elementy_list.Count - 1 do
          if    ( TSchemat_Element(schemat_elementy_list[ k ]).animacja__element_etap = aee_Brak )
            and ( TSchemat_Element(schemat_elementy_list[ k ]).animacja__krok = animacja__krok__aktualny_g )
            and (  Abs( TSchemat_Element(schemat_elementy_list[ k ]).kolumna - kolumna_kopia ) <= schemat_ustawienia_r_g.animacja__promień  )
            and (  Abs( TSchemat_Element(schemat_elementy_list[ k ]).wiersz - wiersz_kopia ) <= schemat_ustawienia_r_g.animacja__promień  ) then
            begin

              TSchemat_Element(schemat_elementy_list[ k ]).animacja__element_etap := aee_Element_Animowany;
              // Elementy w promieniu nie mają włączanych efektów.

              zti := 0; // Tutaj tymczasowo jako sprawdzenie czy znalazł wyszukiwany indeks.

              // Usuwanie elementów w promieniu wylosowanego elementu z tabeli.
              for l := 0 to Length( schemat_elementy_losowanie_t ) - 2 do
                begin

                  if    ( zti = 0 )
                    and ( schemat_elementy_losowanie_t[ l ] = k ) then
                    zti := 1;

                  if zti = 1 then
                    schemat_elementy_losowanie_t[ l ] := schemat_elementy_losowanie_t[ l + 1 ];

                end;
              //---//for l := 0 to Length( schemat_elementy_losowanie_t ) - 2 do

              if    ( zti = 1 )
                and (  Length( schemat_elementy_losowanie_t ) >= 1  ) then
                SetLength(  schemat_elementy_losowanie_t, Length( schemat_elementy_losowanie_t ) - 1  );

            end;
          //---//if    ( TSchemat_Element(schemat_elementy_list[ k ]).animacja__element_etap = aee_Brak ) (...)


      if Length( schemat_elementy_losowanie_t ) <= 0 then
        Break;

    end;
  //---//for i := 1 to losowania_ilość do

  losowanie__elementu__kolejne__losowy__czas_milisekundy_i := Random( losowanie__elementu__kolejne__zakres__czas_milisekundy_i + 1 );

  losowanie__elementu__ostatnie_czas_milisekundy_i := Czas_Teraz_W_Milisekundach();

end;//---//Funkcja Schemat__Losuj().

//Funkcja Schemat__Odśwież().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Schemat__Odśwież();
begin

  animacja__etap_g := ae_Brak;
  //animacja__etap__czas_zmiany_ostatniej_g := Now();
  animacja__etap__czas_milisekundy_i := Czas_Teraz_W_Milisekundach();
  Animacja_Etap_Informacja();


  if not Schemat__Wczytaj() then
    Exit;


  animacja__etap_g := ae_Brak;
  //animacja__etap__czas_zmiany_ostatniej_g := Now();
  animacja__etap__czas_milisekundy_i := Czas_Teraz_W_Milisekundach();
  Animacja_Etap_Informacja();

end;//---//Funkcja Schemat__Odśwież().

//Funkcja Schemat__Ustawienia_Odśwież().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Schemat__Ustawienia_Odśwież();
var
  i : integer;
  kursor_kopia : TCursor; // Ta funkcja może zostać wywołana w trakcie trwania jakiejś 'długiej' operacji.
begin

  // Schematy_ComboBox.Text czy schemat_wczytany_g //???

  if   ( schemat_elementy_list = nil )
    or (  not Assigned( schemat_elementy_list )  )
    or ( śnieg_efekt_list = nil )
    or (  not Assigned( śnieg_efekt_list )  )
    or (  Trim( Schematy_ComboBox.Text ) = ''  ) then
    Exit;


  kursor_kopia := Screen.Cursor;
  Screen.Cursor := crHourGlass;


  // Jeżeli nie ma pliku z ustawieniami to zmieni tylko rodzaj animacji.
  if FileExists(  ExtractFilePath( Application.ExeName ) + schematy_katalog_nazwa_c + '\' + Schematy_ComboBox.Text + '.ini'  ) then
    Ustawienia_Plik( Schematy_ComboBox.Text );


  for i := 0 to śnieg_efekt_list.Count - 1 do
    begin

      TŚnieg_Efekt(śnieg_efekt_list[ i ]).Parametry__Ustaw( schemat_ustawienia_r_g, y__min_g );
      TŚnieg_Efekt(śnieg_efekt_list[ i ]).Parametry__Sprawdź( y__min_g );

    end;
  //---//for i := 0 to śnieg_efekt_list.Count - 1 do


  for i := 0 to schemat_elementy_list.Count - 1 do
    begin

      TSchemat_Element(schemat_elementy_list[ i ]).Parametry__Ustaw( schemat_ustawienia_r_g, 0, 0, true );
      TSchemat_Element(schemat_elementy_list[ i ]).Parametry__Sprawdź( y__min_g );

    end;
  //---//for i := 0 to schemat_elementy_list.Count - 1 do


  Screen.Cursor := kursor_kopia;

end;//---//Funkcja Schemat__Ustawienia_Odśwież().

//Funkcja Schemat__Wczytaj().
function TAnimacja__BabyMetal__Kaelan_Mikla__Form.Schemat__Wczytaj() : boolean;
var
  wiersze,
  kolumny,
  animacja__krok_l
    : integer;
  ztsi,
  x__min, // Lewo.
  x__max // Prawo.
    : single;
  ztdt : TDateTime;
  zts : string;
  zt_string_list : TStringList;
  zt_schemat_element : TSchemat_Element;
  zt_śnieg_efekt : TŚnieg_Efekt;
begin

  Result := false;


  if   ( trwa__wczytywanie_schematu_g )
    or ( trwa__zwalnianie_schematu_g )
    or ( schemat_elementy_list = nil )
    or (  not Assigned( schemat_elementy_list )  )
    or ( śnieg_efekt_list = nil )
    or (  not Assigned( śnieg_efekt_list )  ) then
    Exit;


  if Trim( Schematy_ComboBox.Text ) = '' then
    begin

      PageControl1.ActivePage := Opcje_TabSheet;

      if PageControl1.Width <= 1 then
        PageControl1.Width := 200;

      Schematy_ComboBox.SetFocus();
      Komunikat_Wyświetl( 'Należy wskazać schemat.' + #13 + #13 + #13 + 'Schema sollte angegeben werden.' + #13 + #13 + 'Scheme should be indicated.', 'Informacja', MB_OK + MB_ICONEXCLAMATION );
      Exit;

    end;
  //---//if Trim( Schematy_ComboBox.Text ) = '' then


  zts := ExtractFilePath( Application.ExeName ) + schematy_katalog_nazwa_c + '\' + Schematy_ComboBox.Text + '.txt';


  if not FileExists( zts ) then
    begin

      PageControl1.ActivePage := Opcje_TabSheet;

      if PageControl1.Width <= 1 then
        PageControl1.Width := 200;

      Schematy_ComboBox.SetFocus();
      Komunikat_Wyświetl( 'Nie odnaleziono pliku schematu (' + Schematy_ComboBox.Text + '.txt).' + #13 + #13 + #13 + 'Schemadatei nicht gefunden.' + #13 + #13 + 'Schema file not found.', 'Informacja', MB_OK + MB_ICONEXCLAMATION );
      Exit;

    end;
  //---//if not FileExists( zts ) then


  if   ( schemat_elementy_list.Count > 0 )
    or ( śnieg_efekt_list.Count > 0 ) then
    Schemat__Zwolnij()
  else//if   ( schemat_elementy_list.Count > 0 ) (...)
    begin

      Elementy_Ilość_Label.Caption := '0';
      Śnieg_Efekt_Ilość.Caption := '0';

    end;
  //---//if   ( schemat_elementy_list.Count > 0 ) (...)


  trwa__wczytywanie_schematu_g := true;
  Screen.Cursor := crHourGlass;


  animacja__krokowa_g := false;
  animacja__krok__aktualny_g := 1;
  animacja__krok__ostatni_g := 1;
  x__min := 0;
  x__max := 0;
  y__min_g := 0;


  Ustawienia_Plik( Schematy_ComboBox.Text );


  zt_string_list := TStringList.Create();
  zt_string_list.LoadFromFile( zts );

  ProgressBar1.Position := 0;
  ProgressBar1.Max := zt_string_list.Count;

  ProgressBar1__Widoczność_Ustaw();


  ztdt := Now();


  for wiersze := 0 to zt_string_list.Count - 1 do
    begin

      zts := zt_string_list[ wiersze ];


      ProgressBar2.Position := 0;
      ProgressBar2.Max := Length( zts );


      for kolumny := 1 to Length( zts ) do
        begin

          if Trim( zts[ kolumny ] ) <> '' then
            begin

              zt_schemat_element := TSchemat_Element.Create( nil, Gra_Obiekty_GLDummyCube, GLCadencer1 ); // Z Owner nil zamiast Application działa szybciej.
              zt_schemat_element.Parametry__Ustaw( schemat_ustawienia_r_g, kolumny, -wiersze - 1 ); // Aby wiersze i kolumny były indeksowane tak samo od 1.

              try
                zt_schemat_element.animacja__krok := StrToInt( zts[ kolumny ] );
              except
              end;
              //---//try

              if   ( schemat_elementy_list.Count = 0 )
                or ( animacja__krok__aktualny_g > zt_schemat_element.animacja__krok ) then
                animacja__krok__aktualny_g := zt_schemat_element.animacja__krok;

              if   ( schemat_elementy_list.Count = 0 )
                or ( animacja__krok__ostatni_g < zt_schemat_element.animacja__krok ) then
                animacja__krok__ostatni_g := zt_schemat_element.animacja__krok;

              if schemat_elementy_list.Count = 0 then
                animacja__krok_l := animacja__krok__aktualny_g
              else//if schemat_elementy_list.Count = 0 then
                if    ( not animacja__krokowa_g )
                  and ( animacja__krok_l <> zt_schemat_element.animacja__krok ) then
                  animacja__krokowa_g := true;


              schemat_elementy_list.Add( zt_schemat_element );


              if schemat_elementy_list.Count = 1 then
                begin

                  x__min := zt_schemat_element.Position.X;
                  x__max := zt_schemat_element.Position.X;
                  y__min_g := zt_schemat_element.Position.Y

                end
              else//if schemat_elementy_list.Count = 1 then
                begin

                  if x__min > zt_schemat_element.Position.X then
                    x__min := zt_schemat_element.Position.X;

                  if x__max < zt_schemat_element.Position.X then
                    x__max := zt_schemat_element.Position.X;

                  if y__min_g > zt_schemat_element.Position.Y then
                    y__min_g := zt_schemat_element.Position.Y;

                end;
              //---//if schemat_elementy_list.Count = 1 then

            end;
          //---//if Trim( zts[ kolumny ] ) <> '' then


          if ProgressBar1.Parent = Opcje_TabSheet then
            begin

              ProgressBar2.StepIt();

              if ProgressBar1.Parent = Opcje_TabSheet then
                //if kolumny mod 100 = 0 then
                if MilliSecondsBetween( Now(), ztdt ) >= postęp_odświeżanie_milisekundy_c then
                  begin

                    Application.ProcessMessages();
                    ztdt := Now();

                  end;
                //---//if MilliSecondsBetween( Now(), ztdt ) >= postęp_odświeżanie_milisekundy_c then

            end;
          //---//if ProgressBar1.Parent = Opcje_TabSheet then


          if przerwij_wczytywanie_schematu_g then
            Break;

        end;
      //---//for kolumny := 1 to Length( zts ) do


      Elementy_Ilość_Label.Caption := Trim(  FormatFloat( '### ### ##0', schemat_elementy_list.Count )  );

      ProgressBar1.StepIt();

      //Application.ProcessMessages();
      if MilliSecondsBetween( Now(), ztdt ) >= postęp_odświeżanie_milisekundy_c then
        begin

          ProgressBar1__Widoczność_Ustaw();

          Application.ProcessMessages();

          ztdt := Now();

        end;
      //---//if MilliSecondsBetween( Now(), ztdt ) >= postęp_odświeżanie_milisekundy_c then


      if przerwij_wczytywanie_schematu_g then
        Break;

    end;
  //---//for wiersze := 0 to zt_string_list.Count - 1 do

  FreeAndNil( zt_string_list );


  ztdt := Now();


  if schemat_ustawienia_r_g.śnieg__efekt__rzadkość > 0 then
    begin

      // Dodaje margines efektu śniegu - połowa odległości elementów schematu w osi x.
      ztsi := Abs( x__min + x__max ) * schemat_ustawienia_r_g.śnieg__efekt__margines;
      x__min := x__min - ztsi;
      x__max := x__max + ztsi;

      ztsi := x__min;

      while ztsi <= x__max do
        begin

          zt_śnieg_efekt := TŚnieg_Efekt.Create( nil, Gra_Obiekty_GLDummyCube, GLCadencer1 ); // Z Owner nil zamiast Application działa szybciej.

          zt_śnieg_efekt.Parametry__Ustaw( schemat_ustawienia_r_g, y__min_g );
          zt_śnieg_efekt.Parametry__Sprawdź( y__min_g );

          zt_śnieg_efekt.Position.X := ztsi;
          zt_śnieg_efekt.Position.Z := zt_śnieg_efekt.Scale.X;


          śnieg_efekt_list.Add( zt_śnieg_efekt );

          Śnieg_Efekt_Ilość.Caption := Trim(  FormatFloat( '### ### ##0', śnieg_efekt_list.Count )  );


          ztsi := ztsi + zt_śnieg_efekt.Scale.X * schemat_ustawienia_r_g.śnieg__efekt__rzadkość;


          //if śnieg_efekt_list.Count mod 10 = 0 then
          //  Application.ProcessMessages();
          if MilliSecondsBetween( Now(), ztdt ) >= postęp_odświeżanie_milisekundy_c then
            begin

              Application.ProcessMessages();
              ztdt := Now();

            end;
          //---//if MilliSecondsBetween( Now(), ztdt ) >= postęp_odświeżanie_milisekundy_c then


          if przerwij_wczytywanie_schematu_g then
            Break;

        end;
      //---//while ztsi <= x__max do

    end;
  //---//if schemat_ustawienia_r_g.śnieg__efekt__rzadkość > 0 then


  animacja__krok__aktualny_kopia_g := animacja__krok__aktualny_g;
  schemat_wczytany_g := Schematy_ComboBox.Text;


  for wiersze := 0 to schemat_elementy_list.Count - 1 do
    begin

      TSchemat_Element(schemat_elementy_list[ wiersze ]).efekt_gl_dummy_cube.MoveLast(); // Nie widać efektów na tle elementów.
      TSchemat_Element(schemat_elementy_list[ wiersze ]).Parametry__Sprawdź( y__min_g );

    end;
  //---//for wiersze := 0 to schemat_elementy_list.Count - 1 do


  Schematy_Informacja_Label.Hint :=
    'Animacja krokowa: ';

  if animacja__krokowa_g then
    Schematy_Informacja_Label.Hint := Schematy_Informacja_Label.Hint +
      'tak;' + #13 +
      'krok pierwszy: ' + Trim(  FormatFloat( '### ### ##0', animacja__krok__aktualny_g )  ) + ';' + #13 +
      'krok ostatni: ' + Trim(  FormatFloat( '### ### ##0', animacja__krok__ostatni_g )  ) + '.'
  else//if animacja__krokowa_g then
    Schematy_Informacja_Label.Hint := Schematy_Informacja_Label.Hint +
      'nie.';


  Schematy_Informacja_Label.Hint := Schematy_Informacja_Label.Hint +
    #13 + #13 +
    'Schrittanimation: ';

  if animacja__krokowa_g then
    Schematy_Informacja_Label.Hint := Schematy_Informacja_Label.Hint +
      'ja;' + #13 +
      'erster Schritt: ' + Trim(  FormatFloat( '### ### ##0', animacja__krok__aktualny_g )  ) + ';' + #13 +
      'letzter Schritt: ' + Trim(  FormatFloat( '### ### ##0', animacja__krok__ostatni_g )  ) + '.'
  else//if animacja__krokowa_g then
    Schematy_Informacja_Label.Hint := Schematy_Informacja_Label.Hint +
      'nein.';


  Schematy_Informacja_Label.Hint := Schematy_Informacja_Label.Hint +
    #13 + #13 +
    'Step animation: ';

  if animacja__krokowa_g then
    Schematy_Informacja_Label.Hint := Schematy_Informacja_Label.Hint +
      'yes;' + #13 +
      'first step: ' + Trim(  FormatFloat( '### ### ##0', animacja__krok__aktualny_g )  ) + ';' + #13 +
      'last step: ' + Trim(  FormatFloat( '### ### ##0', animacja__krok__ostatni_g )  ) + '.'
  else//if animacja__krokowa_g then
    Schematy_Informacja_Label.Hint := Schematy_Informacja_Label.Hint +
      'no.';


  animacja__etap_g := ae_Schemat_Wczytany;
  //animacja__etap__czas_zmiany_ostatniej_g := Now();
  animacja__etap__czas_milisekundy_i := Czas_Teraz_W_Milisekundach();
  Animacja_Etap_Informacja();


  ProgressBar1__Widoczność_Ustaw( false );


  Screen.Cursor := crDefault;


  if Kamera_Ustaw_CheckBox.Checked then
    Schemat__Kamera_Ustaw();


  if przerwij_wczytywanie_schematu_g then
    przerwij_wczytywanie_schematu_g := false;


  trwa__wczytywanie_schematu_g := false;


  Result := true;

end;//---//Funkcja Schemat__Wczytaj().

//Funkcja Schemat__Zwolnij().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Schemat__Zwolnij();
var
  i : integer;
  ztdt : TDateTime;
begin

  if trwa__wczytywanie_schematu_g then
    begin

      if not przerwij_wczytywanie_schematu_g then
        przerwij_wczytywanie_schematu_g := true;

      Exit;

    end;
  //---//if trwa__wczytywanie_schematu_g then


  if   ( trwa__zwalnianie_schematu_g )
    or ( schemat_elementy_list = nil )
    or (  not Assigned( schemat_elementy_list )  )
    or ( śnieg_efekt_list = nil )
    or (  not Assigned( śnieg_efekt_list )  ) then
    Exit;


  trwa__zwalnianie_schematu_g := true;
  Screen.Cursor := crHourGlass;


  if not Czy_Pauza() then
    Pauza();


  animacja__etap_g := ae_Brak;
  Animacja_Etap_Informacja();


  ProgressBar1.Position := 0;
  ProgressBar2.Position := 0;
  ProgressBar1.Max := schemat_elementy_list.Count + śnieg_efekt_list.Count;

  ProgressBar1__Widoczność_Ustaw();


  ztdt := Now();


  for i := śnieg_efekt_list.Count - 1 downto 0 do
    begin

      TŚnieg_Efekt(śnieg_efekt_list[ i ]).Free();
      śnieg_efekt_list.Delete( i );


      Śnieg_Efekt_Ilość.Caption := Trim(  FormatFloat( '### ### ##0', śnieg_efekt_list.Count )  );

      ProgressBar1.StepIt();

      //if i mod 10 = 0 then
      //  Application.ProcessMessages();
      if MilliSecondsBetween( Now(), ztdt ) >= postęp_odświeżanie_milisekundy_c then
        begin

          ProgressBar1__Widoczność_Ustaw();

          Application.ProcessMessages();

          ztdt := Now();

        end;
      //---//if MilliSecondsBetween( Now(), ztdt ) >= postęp_odświeżanie_milisekundy_c then

    end;
  //---//for i := śnieg_efekt_list.Count - 1 downto 0 do


  for i := schemat_elementy_list.Count - 1 downto 0 do
    begin

      TSchemat_Element(schemat_elementy_list[ i ]).Free();
      schemat_elementy_list.Delete( i );


      Elementy_Ilość_Label.Caption := Trim(  FormatFloat( '### ### ##0', schemat_elementy_list.Count )  );

      ProgressBar1.StepIt();

      //if i mod 100 = 0 then
      //  Application.ProcessMessages();
      if MilliSecondsBetween( Now(), ztdt ) >= postęp_odświeżanie_milisekundy_c then
        begin

          ProgressBar1__Widoczność_Ustaw();

          Application.ProcessMessages();

          ztdt := Now();

        end;
      //---//if MilliSecondsBetween( Now(), ztdt ) >= postęp_odświeżanie_milisekundy_c then

    end;
  //---//for i := schemat_elementy_list.Count - 1 downto 0 do


  SetLength( rozbłyski_losowanie_t, 0 );
  SetLength( schemat_elementy_losowanie_t, 0 );

  schemat_wczytany_g := '';
  y__min_g := 0;
  Elementy_Ilość_Label.Caption := Trim(  FormatFloat( '### ### ##0', schemat_elementy_list.Count )  );
  Śnieg_Efekt_Ilość.Caption := Trim(  FormatFloat( '### ### ##0', śnieg_efekt_list.Count )  );

  //animacja__etap_g := ae_Brak;
  //animacja__etap__czas_zmiany_ostatniej_g := Now();
  animacja__etap__czas_milisekundy_i := Czas_Teraz_W_Milisekundach();
  //Animacja_Etap_Informacja();


  ProgressBar1__Widoczność_Ustaw( false );


  trwa__zwalnianie_schematu_g := false;
  Screen.Cursor := crDefault;

end;//---//Funkcja Schemat__Zwolnij().

//Funkcja Ustawienia_Plik().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Ustawienia_Plik( const schemat_nazwa_f : string; const zapisuj_ustawienia_f : boolean = false );
var
  i : integer;
  zts : string;
  plik_ini : TIniFile; // uses IniFiles.
begin

  //
  // Funkcja wczytuje i zapisuje ustawienia.
  //
  //  Nie tworzy automatycznie plików dla schematów (należy je utworzyć ręcznie na podstawie wzorca - plik_ini_wzorcowy_nazwa_c).
  //
  // Parametry:
  //   zapisuj_ustawienia_f:
  //     false - tylko odczytuje ustawienia.
  //     true - zapisuje ustawienia.
  //

  //falowanie__pytanie_zadane_g := false;

  {$region 'Wartości domyślne.'}
  schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_milisekundy := 3000;
  schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_kolejnego_kroku_milisekundy := 1000;
  schemat_ustawienia_r_g.animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy := 10000;


  schemat_ustawienia_r_g.animacja__rodzaj_su := TAnimacja_Rodzaj(Animacja_Rodzaj_RadioGroup.ItemIndex);
  schemat_ustawienia_r_g.animacja__rodzaj__zalecana_s_su := '';

  schemat_ustawienia_r_g.animacja__promień := 0;
  schemat_ustawienia_r_g.animacja__szybkość_zmiany_przeźroczystości := 0.25;

  schemat_ustawienia_r_g.element__kolor__r := 0.6;
  schemat_ustawienia_r_g.element__kolor__g := 0.6;
  schemat_ustawienia_r_g.element__kolor__b := 0.6;

  schemat_ustawienia_r_g.element__skala := 1;

  schemat_ustawienia_r_g.element__efekt__fire_burst := 0.1;
  schemat_ustawienia_r_g.element__efekt__fire_crown := 1;
  schemat_ustawienia_r_g.element__efekt__fire_density := 8;
  //schemat_ustawienia_r_g.element__efekt__fire_dir_y := -0.5;
  schemat_ustawienia_r_g.element__efekt__fire_evaporation := 1.3;
  schemat_ustawienia_r_g.element__efekt__fire_radius := 0.1;
  //schemat_ustawienia_r_g.element__efekt__initial_dir_y := -1;
  schemat_ustawienia_r_g.element__efekt__kolor__inner__r := 0.6;
  schemat_ustawienia_r_g.element__efekt__kolor__inner__g := 0.6;
  schemat_ustawienia_r_g.element__efekt__kolor__inner__b := 0.6;
  schemat_ustawienia_r_g.element__efekt__kolor__outer__r := 1;
  schemat_ustawienia_r_g.element__efekt__kolor__outer__g := 1;
  schemat_ustawienia_r_g.element__efekt__kolor__outer__b := 1;
  schemat_ustawienia_r_g.element__efekt__particle_interval := 0.25;
  schemat_ustawienia_r_g.element__efekt__particle_life := 40;
  schemat_ustawienia_r_g.element__efekt__particle_size := 0.4;
  schemat_ustawienia_r_g.element__efekt__skala := 0.5;

  schemat_ustawienia_r_g.falowanie__amplituda := 2;
  schemat_ustawienia_r_g.falowanie__kolumna_następna__oczekiwanie__milisekundy := 250;
  schemat_ustawienia_r_g.falowanie__szybkość := 1;
  schemat_ustawienia_r_g.falowanie__włączone := false;

  schemat_ustawienia_r_g.losowanie__elementu__ilość_jednocześnie := 0;
  schemat_ustawienia_r_g.losowanie__elementu__kolejne_milisekundy := 1000;
  schemat_ustawienia_r_g.losowanie__rozbłysku__kolejne_milisekundy := 1000;

  schemat_ustawienia_r_g.śnieg__efekt__fire_burst := 0.5;
  schemat_ustawienia_r_g.śnieg__efekt__fire_crown := 20;
  schemat_ustawienia_r_g.śnieg__efekt__fire_density := 12;
  //schemat_ustawienia_r_g.śnieg__efekt__fire_dir_y := -0.5;
  schemat_ustawienia_r_g.śnieg__efekt__fire_evaporation := 2.2;
  schemat_ustawienia_r_g.śnieg__efekt__fire_radius := 1;
  //schemat_ustawienia_r_g.śnieg__efekt__initial_dir_y := -1;
  schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__r := 1;
  schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__g := 1;
  schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__b := 1;
  schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__r := 1;
  schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__g := 1;
  schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__b := 1;
  schemat_ustawienia_r_g.śnieg__efekt__margines := 0.5;
  schemat_ustawienia_r_g.śnieg__efekt__particle_interval := 1;
  schemat_ustawienia_r_g.śnieg__efekt__particle_life := 50;
  schemat_ustawienia_r_g.śnieg__efekt__particle_size := 0.8;
  schemat_ustawienia_r_g.śnieg__efekt__pozycja_y := -9999;
  schemat_ustawienia_r_g.śnieg__efekt__rzadkość := 3;
  schemat_ustawienia_r_g.śnieg__efekt__skala := 1;
  schemat_ustawienia_r_g.śnieg__efekt__visible_at_run_time := false;

  schemat_ustawienia_r_g.śnieg__rozbłysk__fire_burst := 0.1;
  schemat_ustawienia_r_g.śnieg__rozbłysk__fire_crown := 1;
  schemat_ustawienia_r_g.śnieg__rozbłysk__fire_density := 8;
  schemat_ustawienia_r_g.śnieg__rozbłysk__fire_evaporation := 1.3;
  schemat_ustawienia_r_g.śnieg__rozbłysk__fire_radius := 0.1;
  schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__inner__r := 0;
  schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__inner__g := 0.8;
  schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__inner__b := 0.5;
  schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__outer__r := 0;
  schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__outer__g := 0;
  schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__outer__b := 1;
  schemat_ustawienia_r_g.śnieg__rozbłysk__life_boost_factor := 1;
  schemat_ustawienia_r_g.śnieg__rozbłysk__max_initial_speed := 1;
  schemat_ustawienia_r_g.śnieg__rozbłysk__min_initial_speed := 0.5;
  schemat_ustawienia_r_g.śnieg__rozbłysk__nb_particles := 15;
  schemat_ustawienia_r_g.śnieg__rozbłysk__particle_interval := 0.25;
  schemat_ustawienia_r_g.śnieg__rozbłysk__particle_life := 10;
  schemat_ustawienia_r_g.śnieg__rozbłysk__particle_size := 0.4;
  schemat_ustawienia_r_g.śnieg__rozbłysk__skala := 1;

  schemat_ustawienia_r_g.tło__kolor__r := 0;
  schemat_ustawienia_r_g.tło__kolor__g := 0;
  schemat_ustawienia_r_g.tło__kolor__b := 0;

  schemat_ustawienia_r_g.wiatr__siła_maksymalna := 10;
  schemat_ustawienia_r_g.wiatr__zmiana_kolejna__sekundy := 10;
  {$endregion 'Wartości domyślne.'}


  zts := ExtractFilePath( Application.ExeName ) + schematy_katalog_nazwa_c + '\' + schemat_nazwa_f + '.ini';

  if    (  Trim( schemat_nazwa_f ) <> ''  )
    and (
             ( zapisuj_ustawienia_f )
          or (  FileExists( zts ) )
        ) then
    begin

      plik_ini := TIniFile.Create( zts );


      {$region 'Obsługa pliku ini.'}
      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ANIMACJA', 'animacja__oczekiwanie_do_rozpoczęcia_milisekundy' )  ) then
        plik_ini.WriteInteger( 'ANIMACJA', 'animacja__oczekiwanie_do_rozpoczęcia_milisekundy', schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_milisekundy )
      else
        schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_milisekundy := plik_ini.ReadInteger( 'ANIMACJA', 'animacja__oczekiwanie_do_rozpoczęcia_milisekundy', schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_milisekundy );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ANIMACJA', 'animacja__oczekiwanie_do_rozpoczęcia_kolejnego_kroku_milisekundy' )  ) then
        plik_ini.WriteInteger( 'ANIMACJA', 'animacja__oczekiwanie_do_rozpoczęcia_kolejnego_kroku_milisekundy', schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_kolejnego_kroku_milisekundy )
      else
        schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_kolejnego_kroku_milisekundy := plik_ini.ReadInteger( 'ANIMACJA', 'animacja__oczekiwanie_do_rozpoczęcia_kolejnego_kroku_milisekundy', schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_kolejnego_kroku_milisekundy );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ANIMACJA', 'animacja__promień' )  ) then
        plik_ini.WriteInteger( 'ANIMACJA', 'animacja__promień', schemat_ustawienia_r_g.animacja__promień )
      else
        schemat_ustawienia_r_g.animacja__promień := plik_ini.ReadInteger( 'ANIMACJA', 'animacja__promień', schemat_ustawienia_r_g.animacja__promień );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ANIMACJA', 'animacja__rodzaj__zalecana' )  ) then
        plik_ini.WriteString( 'ANIMACJA', 'animacja__rodzaj__zalecana', schemat_ustawienia_r_g.animacja__rodzaj__zalecana_s_su )
      else
        schemat_ustawienia_r_g.animacja__rodzaj__zalecana_s_su := plik_ini.ReadString( 'ANIMACJA', 'animacja__rodzaj__zalecana', schemat_ustawienia_r_g.animacja__rodzaj__zalecana_s_su );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ANIMACJA', 'animacja__szybkość_zmiany_przeźroczystości' )  ) then
        plik_ini.WriteFloat( 'ANIMACJA', 'animacja__szybkość_zmiany_przeźroczystości', schemat_ustawienia_r_g.animacja__szybkość_zmiany_przeźroczystości )
      else
        schemat_ustawienia_r_g.animacja__szybkość_zmiany_przeźroczystości := plik_ini.ReadFloat( 'ANIMACJA', 'animacja__szybkość_zmiany_przeźroczystości', schemat_ustawienia_r_g.animacja__szybkość_zmiany_przeźroczystości );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ANIMACJA', 'animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy' )  ) then
        plik_ini.WriteInteger( 'ANIMACJA', 'animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy', schemat_ustawienia_r_g.animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy )
      else
        schemat_ustawienia_r_g.animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy := plik_ini.ReadInteger( 'ANIMACJA', 'animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy', schemat_ustawienia_r_g.animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ANIMACJA', 'losowanie__elementu__ilość_jednocześnie' )  ) then
        plik_ini.WriteInteger( 'ANIMACJA', 'losowanie__elementu__ilość_jednocześnie', schemat_ustawienia_r_g.losowanie__elementu__ilość_jednocześnie )
      else
        schemat_ustawienia_r_g.losowanie__elementu__ilość_jednocześnie := plik_ini.ReadInteger( 'ANIMACJA', 'losowanie__elementu__ilość_jednocześnie', schemat_ustawienia_r_g.losowanie__elementu__ilość_jednocześnie );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ANIMACJA', 'losowanie__elementu__kolejne_milisekundy' )  ) then
        plik_ini.WriteInteger( 'ANIMACJA', 'losowanie__elementu__kolejne_milisekundy', schemat_ustawienia_r_g.losowanie__elementu__kolejne_milisekundy )
      else
        schemat_ustawienia_r_g.losowanie__elementu__kolejne_milisekundy := plik_ini.ReadInteger( 'ANIMACJA', 'losowanie__elementu__kolejne_milisekundy', schemat_ustawienia_r_g.losowanie__elementu__kolejne_milisekundy );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ANIMACJA', 'losowanie__rozbłysku__kolejne_milisekundy' )  ) then
        plik_ini.WriteInteger( 'ANIMACJA', 'losowanie__rozbłysku__kolejne_milisekundy', schemat_ustawienia_r_g.losowanie__rozbłysku__kolejne_milisekundy )
      else
        schemat_ustawienia_r_g.losowanie__rozbłysku__kolejne_milisekundy := plik_ini.ReadInteger( 'ANIMACJA', 'losowanie__rozbłysku__kolejne_milisekundy', schemat_ustawienia_r_g.losowanie__rozbłysku__kolejne_milisekundy );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ANIMACJA', 'tło__kolor__r' )  ) then
        plik_ini.WriteFloat( 'ANIMACJA', 'tło__kolor__r', schemat_ustawienia_r_g.tło__kolor__r )
      else
        schemat_ustawienia_r_g.tło__kolor__r := plik_ini.ReadFloat( 'ANIMACJA', 'tło__kolor__r', schemat_ustawienia_r_g.tło__kolor__r );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ANIMACJA', 'tło__kolor__g' )  ) then
        plik_ini.WriteFloat( 'ANIMACJA', 'tło__kolor__g', schemat_ustawienia_r_g.tło__kolor__g )
      else
        schemat_ustawienia_r_g.tło__kolor__g := plik_ini.ReadFloat( 'ANIMACJA', 'tło__kolor__g', schemat_ustawienia_r_g.tło__kolor__g );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ANIMACJA', 'tło__kolor__b' )  ) then
        plik_ini.WriteFloat( 'ANIMACJA', 'tło__kolor__b', schemat_ustawienia_r_g.tło__kolor__b )
      else
        schemat_ustawienia_r_g.tło__kolor__b := plik_ini.ReadFloat( 'ANIMACJA', 'tło__kolor__b', schemat_ustawienia_r_g.tło__kolor__b );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ANIMACJA', 'wiatr__siła_maksymalna' )  ) then
        plik_ini.WriteInteger( 'ANIMACJA', 'wiatr__siła_maksymalna', schemat_ustawienia_r_g.wiatr__siła_maksymalna )
      else
        schemat_ustawienia_r_g.wiatr__siła_maksymalna := plik_ini.ReadInteger( 'ANIMACJA', 'wiatr__siła_maksymalna', schemat_ustawienia_r_g.wiatr__siła_maksymalna );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ANIMACJA', 'wiatr__zmiana_kolejna__sekundy' )  ) then
        plik_ini.WriteInteger( 'ANIMACJA', 'wiatr__zmiana_kolejna__sekundy', schemat_ustawienia_r_g.wiatr__zmiana_kolejna__sekundy )
      else
        schemat_ustawienia_r_g.wiatr__zmiana_kolejna__sekundy := plik_ini.ReadInteger( 'ANIMACJA', 'wiatr__zmiana_kolejna__sekundy', schemat_ustawienia_r_g.wiatr__zmiana_kolejna__sekundy );




      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT', 'element__kolor__r' )  ) then
        plik_ini.WriteFloat( 'ELEMENT', 'element__kolor__r', schemat_ustawienia_r_g.element__kolor__r )
      else
        schemat_ustawienia_r_g.element__kolor__r := plik_ini.ReadFloat( 'ELEMENT', 'element__kolor__r', schemat_ustawienia_r_g.element__kolor__r );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT', 'element__kolor__g' )  ) then
        plik_ini.WriteFloat( 'ELEMENT', 'element__kolor__g', schemat_ustawienia_r_g.element__kolor__g )
      else
        schemat_ustawienia_r_g.element__kolor__g := plik_ini.ReadFloat( 'ELEMENT', 'element__kolor__g', schemat_ustawienia_r_g.element__kolor__g );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT', 'element__kolor__b' )  ) then
        plik_ini.WriteFloat( 'ELEMENT', 'element__kolor__b', schemat_ustawienia_r_g.element__kolor__b )
      else
        schemat_ustawienia_r_g.element__kolor__b := plik_ini.ReadFloat( 'ELEMENT', 'element__kolor__b', schemat_ustawienia_r_g.element__kolor__b );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT', 'element__skala' )  ) then
        plik_ini.WriteFloat( 'ELEMENT', 'element__skala', schemat_ustawienia_r_g.element__skala )
      else
        schemat_ustawienia_r_g.element__skala := plik_ini.ReadFloat( 'ELEMENT', 'element__skala', schemat_ustawienia_r_g.element__skala );




      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__fire_burst' )  ) then
        plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__fire_burst', schemat_ustawienia_r_g.element__efekt__fire_burst )
      else
        schemat_ustawienia_r_g.element__efekt__fire_burst := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__fire_burst', schemat_ustawienia_r_g.element__efekt__fire_burst );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__fire_crown' )  ) then
        plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__fire_crown', schemat_ustawienia_r_g.element__efekt__fire_crown )
      else
        schemat_ustawienia_r_g.element__efekt__fire_crown := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__fire_crown', schemat_ustawienia_r_g.element__efekt__fire_crown );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__fire_density' )  ) then
        plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__fire_density', schemat_ustawienia_r_g.element__efekt__fire_density )
      else
        schemat_ustawienia_r_g.element__efekt__fire_density := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__fire_density', schemat_ustawienia_r_g.element__efekt__fire_density );


      //if   (  zapisuj_ustawienia_f )
      //  or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__fire_dir_y' )  ) then
      //  plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__fire_dir_y', schemat_ustawienia_r_g.element__efekt__fire_dir_y )
      //else
      //  schemat_ustawienia_r_g.element__efekt__fire_dir_y := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__fire_dir_y', schemat_ustawienia_r_g.element__efekt__fire_dir_y );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__fire_evaporation' )  ) then
        plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__fire_evaporation', schemat_ustawienia_r_g.element__efekt__fire_evaporation )
      else
        schemat_ustawienia_r_g.element__efekt__fire_evaporation := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__fire_evaporation', schemat_ustawienia_r_g.element__efekt__fire_evaporation );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__fire_radius' )  ) then
        plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__fire_radius', schemat_ustawienia_r_g.element__efekt__fire_radius )
      else
        schemat_ustawienia_r_g.element__efekt__fire_radius := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__fire_radius', schemat_ustawienia_r_g.element__efekt__fire_radius );


      //if   (  zapisuj_ustawienia_f )
      //  or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__initial_dir_y' )  ) then
      //  plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__initial_dir_y', schemat_ustawienia_r_g.element__efekt__initial_dir_y )
      //else
      //  schemat_ustawienia_r_g.element__efekt__initial_dir_y := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__initial_dir_y', schemat_ustawienia_r_g.element__efekt__initial_dir_y );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__kolor__inner__r' )  ) then
        plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__kolor__inner__r', schemat_ustawienia_r_g.element__efekt__kolor__inner__r )
      else
        schemat_ustawienia_r_g.element__efekt__kolor__inner__r := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__kolor__inner__r', schemat_ustawienia_r_g.element__efekt__kolor__inner__r );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__kolor__inner__g' )  ) then
        plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__kolor__inner__g', schemat_ustawienia_r_g.element__efekt__kolor__inner__g )
      else
        schemat_ustawienia_r_g.element__efekt__kolor__inner__g := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__kolor__inner__g', schemat_ustawienia_r_g.element__efekt__kolor__inner__g );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__kolor__inner__b' )  ) then
        plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__kolor__inner__b', schemat_ustawienia_r_g.element__efekt__kolor__inner__b )
      else
        schemat_ustawienia_r_g.element__efekt__kolor__inner__b := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__kolor__inner__b', schemat_ustawienia_r_g.element__efekt__kolor__inner__b );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__kolor__outer__r' )  ) then
        plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__kolor__outer__r', schemat_ustawienia_r_g.element__efekt__kolor__outer__r )
      else
        schemat_ustawienia_r_g.element__efekt__kolor__outer__r := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__kolor__outer__r', schemat_ustawienia_r_g.element__efekt__kolor__outer__r );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__kolor__outer__g' )  ) then
        plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__kolor__outer__g', schemat_ustawienia_r_g.element__efekt__kolor__outer__g )
      else
        schemat_ustawienia_r_g.element__efekt__kolor__outer__g := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__kolor__outer__g', schemat_ustawienia_r_g.element__efekt__kolor__outer__g );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__kolor__outer__b' )  ) then
        plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__kolor__outer__b', schemat_ustawienia_r_g.element__efekt__kolor__outer__b )
      else
        schemat_ustawienia_r_g.element__efekt__kolor__outer__b := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__kolor__outer__b', schemat_ustawienia_r_g.element__efekt__kolor__outer__b );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__particle_interval' )  ) then
        plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__particle_interval', schemat_ustawienia_r_g.element__efekt__particle_interval )
      else
        schemat_ustawienia_r_g.element__efekt__particle_interval := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__particle_interval', schemat_ustawienia_r_g.element__efekt__particle_interval );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__particle_life' )  ) then
        plik_ini.WriteInteger( 'ELEMENT_EFEKT', 'element__efekt__particle_life', schemat_ustawienia_r_g.element__efekt__particle_life )
      else
        schemat_ustawienia_r_g.element__efekt__particle_life := plik_ini.ReadInteger( 'ELEMENT_EFEKT', 'element__efekt__particle_life', schemat_ustawienia_r_g.element__efekt__particle_life );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__particle_size' )  ) then
        plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__particle_size', schemat_ustawienia_r_g.element__efekt__particle_size )
      else
        schemat_ustawienia_r_g.element__efekt__particle_size := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__particle_size', schemat_ustawienia_r_g.element__efekt__particle_size );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ELEMENT_EFEKT', 'element__efekt__skala' )  ) then
        plik_ini.WriteFloat( 'ELEMENT_EFEKT', 'element__efekt__skala', schemat_ustawienia_r_g.element__efekt__skala )
      else
        schemat_ustawienia_r_g.element__efekt__skala := plik_ini.ReadFloat( 'ELEMENT_EFEKT', 'element__efekt__skala', schemat_ustawienia_r_g.element__efekt__skala );




      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'FALOWANIE', 'falowanie__amplituda' )  ) then
        plik_ini.WriteFloat( 'FALOWANIE', 'falowanie__amplituda', schemat_ustawienia_r_g.falowanie__amplituda )
      else
        schemat_ustawienia_r_g.falowanie__amplituda := plik_ini.ReadFloat( 'FALOWANIE', 'falowanie__amplituda', schemat_ustawienia_r_g.falowanie__amplituda );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'FALOWANIE', 'falowanie__kolumna_następna__oczekiwanie__milisekundy' )  ) then
        plik_ini.WriteInteger( 'FALOWANIE', 'falowanie__kolumna_następna__oczekiwanie__milisekundy', schemat_ustawienia_r_g.falowanie__kolumna_następna__oczekiwanie__milisekundy )
      else
        schemat_ustawienia_r_g.falowanie__kolumna_następna__oczekiwanie__milisekundy := plik_ini.ReadInteger( 'FALOWANIE', 'falowanie__kolumna_następna__oczekiwanie__milisekundy', schemat_ustawienia_r_g.falowanie__kolumna_następna__oczekiwanie__milisekundy );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'FALOWANIE', 'falowanie__szybkość' )  ) then
        plik_ini.WriteFloat( 'FALOWANIE', 'falowanie__szybkość', schemat_ustawienia_r_g.falowanie__szybkość )
      else
        schemat_ustawienia_r_g.falowanie__szybkość := plik_ini.ReadFloat( 'FALOWANIE', 'falowanie__szybkość', schemat_ustawienia_r_g.falowanie__szybkość );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'FALOWANIE', 'falowanie__włączone' )  ) then
        plik_ini.WriteBool( 'FALOWANIE', 'falowanie__włączone', schemat_ustawienia_r_g.falowanie__włączone )
      else
        schemat_ustawienia_r_g.falowanie__włączone := plik_ini.ReadBool( 'FALOWANIE', 'falowanie__włączone', schemat_ustawienia_r_g.falowanie__włączone );




      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_burst' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_burst', schemat_ustawienia_r_g.śnieg__efekt__fire_burst )
      else
        schemat_ustawienia_r_g.śnieg__efekt__fire_burst := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_burst', schemat_ustawienia_r_g.śnieg__efekt__fire_burst );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_crown' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_crown', schemat_ustawienia_r_g.śnieg__efekt__fire_crown )
      else
        schemat_ustawienia_r_g.śnieg__efekt__fire_crown := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_crown', schemat_ustawienia_r_g.śnieg__efekt__fire_crown );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_density' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_density', schemat_ustawienia_r_g.śnieg__efekt__fire_density )
      else
        schemat_ustawienia_r_g.śnieg__efekt__fire_density := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_density', schemat_ustawienia_r_g.śnieg__efekt__fire_density );


      //if   (  zapisuj_ustawienia_f )
      //  or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_dir_y' )  ) then
      //  plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_dir_y', schemat_ustawienia_r_g.śnieg__efekt__fire_dir_y )
      //else
      //  schemat_ustawienia_r_g.śnieg__efekt__fire_dir_y := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_dir_y', schemat_ustawienia_r_g.śnieg__efekt__fire_dir_y );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_evaporation' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_evaporation', schemat_ustawienia_r_g.śnieg__efekt__fire_evaporation )
      else
        schemat_ustawienia_r_g.śnieg__efekt__fire_evaporation := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_evaporation', schemat_ustawienia_r_g.śnieg__efekt__fire_evaporation );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_radius' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_radius', schemat_ustawienia_r_g.śnieg__efekt__fire_radius )
      else
        schemat_ustawienia_r_g.śnieg__efekt__fire_radius := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__fire_radius', schemat_ustawienia_r_g.śnieg__efekt__fire_radius );


      //if   (  zapisuj_ustawienia_f )
      //  or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__initial_dir_y' )  ) then
      //  plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__initial_dir_y', schemat_ustawienia_r_g.śnieg__efekt__initial_dir_y )
      //else
      //  schemat_ustawienia_r_g.śnieg__efekt__initial_dir_y := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__initial_dir_y', schemat_ustawienia_r_g.śnieg__efekt__initial_dir_y );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__inner__r' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__inner__r', schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__r )
      else
        schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__r := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__inner__r', schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__r );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__inner__g' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__inner__g', schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__g )
      else
        schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__g := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__inner__g', schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__g );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__inner__b' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__inner__b', schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__b )
      else
        schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__b := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__inner__b', schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__b );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__outer__r' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__outer__r', schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__r )
      else
        schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__r := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__outer__r', schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__r );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__outer__g' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__outer__g', schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__g )
      else
        schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__g := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__outer__g', schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__g );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__outer__b' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__outer__b', schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__b )
      else
        schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__b := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__kolor__outer__b', schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__b );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__margines' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__margines', schemat_ustawienia_r_g.śnieg__efekt__margines )
      else
        schemat_ustawienia_r_g.śnieg__efekt__margines := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__margines', schemat_ustawienia_r_g.śnieg__efekt__margines );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__particle_interval' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__particle_interval', schemat_ustawienia_r_g.śnieg__efekt__particle_interval )
      else
        schemat_ustawienia_r_g.śnieg__efekt__particle_interval := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__particle_interval', schemat_ustawienia_r_g.śnieg__efekt__particle_interval );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__particle_life' )  ) then
        plik_ini.WriteInteger( 'ŚNIEG_EFEKT', 'śnieg__efekt__particle_life', schemat_ustawienia_r_g.śnieg__efekt__particle_life )
      else
        schemat_ustawienia_r_g.śnieg__efekt__particle_life := plik_ini.ReadInteger( 'ŚNIEG_EFEKT', 'śnieg__efekt__particle_life', schemat_ustawienia_r_g.śnieg__efekt__particle_life );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__particle_size' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__particle_size', schemat_ustawienia_r_g.śnieg__efekt__particle_size )
      else
        schemat_ustawienia_r_g.śnieg__efekt__particle_size := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__particle_size', schemat_ustawienia_r_g.śnieg__efekt__particle_size );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__pozycja_y' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__pozycja_y', schemat_ustawienia_r_g.śnieg__efekt__pozycja_y )
      else
        schemat_ustawienia_r_g.śnieg__efekt__pozycja_y := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__pozycja_y', schemat_ustawienia_r_g.śnieg__efekt__pozycja_y );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__rzadkość' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__rzadkość', schemat_ustawienia_r_g.śnieg__efekt__rzadkość )
      else
        schemat_ustawienia_r_g.śnieg__efekt__rzadkość := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__rzadkość', schemat_ustawienia_r_g.śnieg__efekt__rzadkość );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__skala' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__skala', schemat_ustawienia_r_g.śnieg__efekt__skala )
      else
        schemat_ustawienia_r_g.śnieg__efekt__skala := plik_ini.ReadFloat( 'ŚNIEG_EFEKT', 'śnieg__efekt__skala', schemat_ustawienia_r_g.śnieg__efekt__skala );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_EFEKT', 'śnieg__efekt__visible_at_run_time' )  ) then
        plik_ini.WriteBool( 'ŚNIEG_EFEKT', 'śnieg__efekt__visible_at_run_time', schemat_ustawienia_r_g.śnieg__efekt__visible_at_run_time )
      else
        schemat_ustawienia_r_g.śnieg__efekt__visible_at_run_time := plik_ini.ReadBool( 'ŚNIEG_EFEKT', 'śnieg__efekt__visible_at_run_time', schemat_ustawienia_r_g.śnieg__efekt__visible_at_run_time );




      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__fire_burst' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__fire_burst', schemat_ustawienia_r_g.śnieg__rozbłysk__fire_burst )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__fire_burst := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__fire_burst', schemat_ustawienia_r_g.śnieg__rozbłysk__fire_burst );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__fire_crown' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__fire_crown', schemat_ustawienia_r_g.śnieg__rozbłysk__fire_crown )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__fire_crown := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__fire_crown', schemat_ustawienia_r_g.śnieg__rozbłysk__fire_crown );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__fire_density' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__fire_density', schemat_ustawienia_r_g.śnieg__rozbłysk__fire_density )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__fire_density := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__fire_density', schemat_ustawienia_r_g.śnieg__rozbłysk__fire_density );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__fire_evaporation' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__fire_evaporation', schemat_ustawienia_r_g.śnieg__rozbłysk__fire_evaporation )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__fire_evaporation := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__fire_evaporation', schemat_ustawienia_r_g.śnieg__rozbłysk__fire_evaporation );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__fire_radius' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__fire_radius', schemat_ustawienia_r_g.śnieg__rozbłysk__fire_radius )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__fire_radius := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__fire_radius', schemat_ustawienia_r_g.śnieg__rozbłysk__fire_radius );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__inner__r' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__inner__r', schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__inner__r )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__inner__r := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__inner__r', schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__inner__r );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__inner__g' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__inner__g', schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__inner__g )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__inner__g := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__inner__g', schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__inner__g );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__inner__b' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__inner__b', schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__inner__b )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__inner__b := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__inner__b', schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__inner__b );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__outer__r' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__outer__r', schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__outer__r )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__outer__r := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__outer__r', schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__outer__r );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__outer__g' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__outer__g', schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__outer__g )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__outer__g := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__outer__g', schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__outer__g );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__outer__b' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__outer__b', schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__outer__b )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__outer__b := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__kolor__outer__b', schemat_ustawienia_r_g.śnieg__rozbłysk__kolor__outer__b );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__life_boost_factor' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__life_boost_factor', schemat_ustawienia_r_g.śnieg__rozbłysk__life_boost_factor )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__life_boost_factor := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__life_boost_factor', schemat_ustawienia_r_g.śnieg__rozbłysk__life_boost_factor );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__max_initial_speed' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__max_initial_speed', schemat_ustawienia_r_g.śnieg__rozbłysk__max_initial_speed )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__max_initial_speed := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__max_initial_speed', schemat_ustawienia_r_g.śnieg__rozbłysk__max_initial_speed );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__min_initial_speed' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__min_initial_speed', schemat_ustawienia_r_g.śnieg__rozbłysk__min_initial_speed )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__min_initial_speed := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__min_initial_speed', schemat_ustawienia_r_g.śnieg__rozbłysk__min_initial_speed );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__nb_particles' )  ) then
        plik_ini.WriteInteger( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__nb_particles', schemat_ustawienia_r_g.śnieg__rozbłysk__nb_particles )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__nb_particles := plik_ini.ReadInteger( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__nb_particles', schemat_ustawienia_r_g.śnieg__rozbłysk__nb_particles );

      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__particle_interval' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__particle_interval', schemat_ustawienia_r_g.śnieg__rozbłysk__particle_interval )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__particle_interval := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__particle_interval', schemat_ustawienia_r_g.śnieg__rozbłysk__particle_interval );

      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__particle_life' )  ) then
        plik_ini.WriteInteger( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__particle_life', schemat_ustawienia_r_g.śnieg__rozbłysk__particle_life )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__particle_life := plik_ini.ReadInteger( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__particle_life', schemat_ustawienia_r_g.śnieg__rozbłysk__particle_life );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__particle_size' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__particle_size', schemat_ustawienia_r_g.śnieg__rozbłysk__particle_size )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__particle_size := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__particle_size', schemat_ustawienia_r_g.śnieg__rozbłysk__particle_size );


      if   (  zapisuj_ustawienia_f )
        or (  not plik_ini.ValueExists( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__skala' )  ) then
        plik_ini.WriteFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__skala', schemat_ustawienia_r_g.śnieg__rozbłysk__skala )
      else
        schemat_ustawienia_r_g.śnieg__rozbłysk__skala := plik_ini.ReadFloat( 'ŚNIEG_ROZBŁYSK', 'śnieg__rozbłysk__skala', schemat_ustawienia_r_g.śnieg__rozbłysk__skala );
      {$endregion 'Obsługa pliku ini.'}


      plik_ini.Free();

    end;
  //---//if    (  Trim( schemat_nazwa_f ) <> ''  ) (...)


  {$region 'Podstawianie i sprawdzanie wartości.'}
  if schemat_ustawienia_r_g.animacja__promień < 0 then
    schemat_ustawienia_r_g.animacja__promień := 0;

  if schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_milisekundy < 0 then
    schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_milisekundy := 3000;

  if schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_kolejnego_kroku_milisekundy < 0 then
    schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_kolejnego_kroku_milisekundy := 1000;


  if schemat_ustawienia_r_g.animacja__szybkość_zmiany_przeźroczystości <= 0 then
    schemat_ustawienia_r_g.animacja__szybkość_zmiany_przeźroczystości := 0.25;


  //if schemat_ustawienia_r_g.animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy < 0 then
  //  schemat_ustawienia_r_g.animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy := 10000;


  if schemat_ustawienia_r_g.element__kolor__r < 0 then
    schemat_ustawienia_r_g.element__kolor__r := 0;

  if schemat_ustawienia_r_g.element__kolor__g < 0 then
    schemat_ustawienia_r_g.element__kolor__g := 0;

  if schemat_ustawienia_r_g.element__kolor__b < 0 then
    schemat_ustawienia_r_g.element__kolor__b := 0;

  if schemat_ustawienia_r_g.element__skala <= 0 then
    schemat_ustawienia_r_g.element__skala := 1;


  if schemat_ustawienia_r_g.element__efekt__kolor__inner__r < 0 then
    schemat_ustawienia_r_g.element__efekt__kolor__inner__r := 0;

  if schemat_ustawienia_r_g.element__efekt__kolor__inner__g < 0 then
    schemat_ustawienia_r_g.element__efekt__kolor__inner__g := 0;

  if schemat_ustawienia_r_g.element__efekt__kolor__inner__b < 0 then
    schemat_ustawienia_r_g.element__efekt__kolor__inner__b := 0;


  if schemat_ustawienia_r_g.element__efekt__kolor__outer__r < 0 then
    schemat_ustawienia_r_g.element__efekt__kolor__outer__r := 0;

  if schemat_ustawienia_r_g.element__efekt__kolor__outer__g < 0 then
    schemat_ustawienia_r_g.element__efekt__kolor__outer__g := 0;

  if schemat_ustawienia_r_g.element__efekt__kolor__outer__b < 0 then
    schemat_ustawienia_r_g.element__efekt__kolor__outer__b := 0;


  if schemat_ustawienia_r_g.element__efekt__skala <= 0 then
    schemat_ustawienia_r_g.element__efekt__skala := 1;


  if schemat_ustawienia_r_g.falowanie__amplituda <= 0 then
    schemat_ustawienia_r_g.falowanie__amplituda := 2;

  if schemat_ustawienia_r_g.falowanie__kolumna_następna__oczekiwanie__milisekundy < 0 then
    schemat_ustawienia_r_g.falowanie__kolumna_następna__oczekiwanie__milisekundy := 250;

  if schemat_ustawienia_r_g.falowanie__szybkość <= 0 then
    schemat_ustawienia_r_g.falowanie__szybkość := 1;


  losowanie__elementu__kolejne__zakres__czas_milisekundy_i := schemat_ustawienia_r_g.losowanie__elementu__kolejne_milisekundy;

  if losowanie__elementu__kolejne__zakres__czas_milisekundy_i < 0 then
    losowanie__elementu__kolejne__zakres__czas_milisekundy_i := 1000;

  losowanie__elementu__kolejne__losowy__czas_milisekundy_i := Random( losowanie__elementu__kolejne__zakres__czas_milisekundy_i + 1 );


  losowanie__rozbłysku__kolejne__zakres__czas_milisekundy_i := schemat_ustawienia_r_g.losowanie__rozbłysku__kolejne_milisekundy;

  //if losowanie__rozbłysku__kolejne__zakres__czas_milisekundy_i < 0 then
  //  losowanie__rozbłysku__kolejne__zakres__czas_milisekundy_i := 1000;

  if losowanie__rozbłysku__kolejne__zakres__czas_milisekundy_i >= 0 then
    losowanie__rozbłysku__kolejne__losowy__czas_milisekundy_i := Random( losowanie__rozbłysku__kolejne__zakres__czas_milisekundy_i + 1 );


  if schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__r < 0 then
    schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__r := 0;

  if schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__g < 0 then
    schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__g := 0;

  if schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__b < 0 then
    schemat_ustawienia_r_g.śnieg__efekt__kolor__inner__b := 0;


  if schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__r < 0 then
    schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__r := 0;

  if schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__g < 0 then
    schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__g := 0;

  if schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__b < 0 then
    schemat_ustawienia_r_g.śnieg__efekt__kolor__outer__b := 0;


  //if schemat_ustawienia_r_g.śnieg__efekt__margines < 0 then //???
  //  schemat_ustawienia_r_g.śnieg__efekt__margines := 0;

  if schemat_ustawienia_r_g.śnieg__efekt__rzadkość < 0 then
    schemat_ustawienia_r_g.śnieg__efekt__rzadkość := 3;

  if schemat_ustawienia_r_g.śnieg__efekt__skala <= 0 then
    schemat_ustawienia_r_g.śnieg__efekt__skala := 1;


  if schemat_ustawienia_r_g.śnieg__rozbłysk__skala <= 0 then
    schemat_ustawienia_r_g.śnieg__rozbłysk__skala := 1;


  if schemat_ustawienia_r_g.tło__kolor__r < 0 then
    schemat_ustawienia_r_g.tło__kolor__r := 0;

  if schemat_ustawienia_r_g.tło__kolor__g < 0 then
    schemat_ustawienia_r_g.tło__kolor__g := 0;

  if schemat_ustawienia_r_g.tło__kolor__b < 0 then
    schemat_ustawienia_r_g.tło__kolor__b := 0;


  if schemat_ustawienia_r_g.wiatr__siła_maksymalna < 0 then
    schemat_ustawienia_r_g.wiatr__siła_maksymalna := 0;


  wiatr_zmiana_kolejna__czas_sekundy_i := schemat_ustawienia_r_g.wiatr__zmiana_kolejna__sekundy;

  if wiatr_zmiana_kolejna__czas_sekundy_i < 1 then
    wiatr_zmiana_kolejna__czas_sekundy_i := 1;

  wiatr_zmiana_kolejna__czas_sekundy_losowy_i := Random( wiatr_zmiana_kolejna__czas_sekundy_i + 1 );
  {$endregion 'Podstawianie i sprawdzanie wartości.'}


  for i := 0 to GLSkyDome1.Bands.Count - 1 do
    begin

       GLSkyDome1.Bands[ i ].StartColor.Red := schemat_ustawienia_r_g.tło__kolor__r;
       GLSkyDome1.Bands[ i ].StartColor.Green := schemat_ustawienia_r_g.tło__kolor__g;
       GLSkyDome1.Bands[ i ].StartColor.Blue := schemat_ustawienia_r_g.tło__kolor__b;

       GLSkyDome1.Bands[ i ].StopColor.Red := schemat_ustawienia_r_g.tło__kolor__r;
       GLSkyDome1.Bands[ i ].StopColor.Green := schemat_ustawienia_r_g.tło__kolor__g;
       GLSkyDome1.Bands[ i ].StopColor.Blue := schemat_ustawienia_r_g.tło__kolor__b;

    end;
  //---//for i := 0 to GLSkyDome1.Bands.Count - 1 do

end;//---//Funkcja Ustawienia_Plik().

//Funkcja Wiatr_Śnieg__Losuj().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Wiatr_Śnieg__Losuj();
var
  i,
  zti,
  wiatr_siła_l
    : integer;
begin

  //
  // Funkcja losuje siłę i kierunek wiatru i śniegu.
  //

  if   ( schemat_elementy_list = nil )
    or (  not Assigned( schemat_elementy_list )  )
    or ( śnieg_efekt_list = nil )
    or (  not Assigned( śnieg_efekt_list )  )
    or (  Czas_Między_W_Sekundach( wiatr_czas_sekundy_i ) < wiatr_zmiana_kolejna__czas_sekundy_i + wiatr_zmiana_kolejna__czas_sekundy_losowy_i  ) then
    Exit;


  if schemat_ustawienia_r_g.wiatr__siła_maksymalna = 0 then
    wiatr_siła_l := 0
  else//if schemat_ustawienia_r_g.wiatr__siła_maksymalna = 0 then
    wiatr_siła_l := System.Math.RandomRange( -schemat_ustawienia_r_g.wiatr__siła_maksymalna, schemat_ustawienia_r_g.wiatr__siła_maksymalna + 1 );


  for i := 0 to śnieg_efekt_list.Count - 1 do
    begin

      TŚnieg_Efekt(śnieg_efekt_list[ i ]).efekt_gl_fire_fx_manager.FireDir.X := wiatr_siła_l * 0.1;


      // Poszczególnym efektom śniegu dodatkowo niezależnie zmienia losowo kierunek.
      if schemat_ustawienia_r_g.wiatr__siła_maksymalna <> 0 then
        begin

          if wiatr_siła_l <> 0 then
            zti := wiatr_siła_l * 3
          else//if wiatr_siła_l <> 0 then
            zti := 3;

          zti := System.Math.RandomRange(  -Abs( zti ), Abs( zti ) + 1  );

          TŚnieg_Efekt(śnieg_efekt_list[ i ]).efekt_gl_fire_fx_manager.FireDir.X := TŚnieg_Efekt(śnieg_efekt_list[ i ]).efekt_gl_fire_fx_manager.FireDir.X +
            zti * 0.01;

        end;
      //---//if schemat_ustawienia_r_g.wiatr__siła_maksymalna <> 0 then

    end;
  //---//for i := 0 to śnieg_efekt_list.Count - 1 do


  if schemat_ustawienia_r_g.animacja__rodzaj_su = ar_BabyMetal then
    for i := 0 to schemat_elementy_list.Count - 1 do
      begin

        TSchemat_Element(schemat_elementy_list[ i ]).efekt_gl_fire_fx_manager.FireDir.X := wiatr_siła_l * 0.1;

        // Poszczególnym efektom wiatru dodatkowo niezależnie zmienia losowo kierunek.
        if schemat_ustawienia_r_g.wiatr__siła_maksymalna <> 0 then
          begin

            if wiatr_siła_l <> 0 then
              zti := wiatr_siła_l * 3
            else//if wiatr_siła_l <> 0 then
              zti := 3;

            zti := System.Math.RandomRange(  -Abs( zti ), Abs( zti ) + 1  );

            TSchemat_Element(schemat_elementy_list[ i ]).efekt_gl_fire_fx_manager.FireDir.X := TSchemat_Element(schemat_elementy_list[ i ]).efekt_gl_fire_fx_manager.FireDir.X +
              zti * 0.01;

          end;
        //---//if schemat_ustawienia_r_g.wiatr__siła_maksymalna <> 0 then

      end;
    //---//for i := 0 to schemat_elementy_list.Count - 1 do


  wiatr_zmiana_kolejna__czas_sekundy_losowy_i := Random( wiatr_zmiana_kolejna__czas_sekundy_i + 1 );

  wiatr_czas_sekundy_i := Czas_Teraz_W_Sekundach();

end;//---//Funkcja Wiatr_Śnieg__Losuj().

//---//      ***      Funkcje      ***      //---//


//FormShow().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.FormShow( Sender: TObject );
begin

  Randomize();

  animacja__etap_g := ae_Brak;
  //animacja__etap__czas_zmiany_ostatniej_g := Now();
  animacja__etap__czas_milisekundy_i := Czas_Teraz_W_Milisekundach();
  gra_współczynnik_prędkości_g := GLCadencer1.TimeMultiplier;
  falowanie__kolumna_poprzednia__falowanie_rozpoczęcie_czas_milisekundy_i := 0;
  falowanie__kolumny_wszystkie_falują_g := false;
  przerwij_wczytywanie_schematu_g := false;
  schemat_wczytany_g := '';
  trwa__wczytywanie_schematu_g := false;
  trwa__zwalnianie_schematu_g := false;
  y__min_g := 0;

  SetLength( rozbłyski_losowanie_t, 0 );
  SetLength( schemat_elementy_losowanie_t, 0 );

  GLCadencer1.CurrentTime := 0;

  schemat_elementy_list := TList.Create();
  śnieg_efekt_list := TList.Create();


  Gra_GLSceneViewer.Align := alClient;
  Konwerter_Obrazów__Obraz_Image.Align := alClient;

  PageControl1.ActivePage := Opcje_TabSheet;

  Pauza();


  Schemat__Lista_Wczytaj();


  Informacja_Ekranowa_TimerTimer( Sender ); // Aby ukryć elementy informacji ekranowej.

  Kursor_GLAsyncTimer.Enabled := true;


  if not FileExists(  ExtractFilePath( Application.ExeName ) + schematy_katalog_nazwa_c + '\' + plik_ini_wzorcowy_nazwa_c + '.ini'  ) then
    Ustawienia_Plik( plik_ini_wzorcowy_nazwa_c, true );

  Ustawienia_Plik( '' );


  Gra_GLSceneViewer.SetFocus();


  Animacja_Etap_Informacja();

end;//---//FormShow().

//FormClose().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.FormClose( Sender: TObject; var Action: TCloseAction );
begin

  {$IFNDEF DEBUG}
  if Komunikat_Wyświetl( 'Czy wyjść z gry?' + #13 + #13 + 'Das Spiel benden?' + #13 + #13 + 'Quit the game?', 'Potwierdzenie', MB_YESNO + MB_DEFBUTTON2 + MB_ICONQUESTION ) <> IDYES then
    begin

      Action := caNone;
      Exit;

    end;
  //---//if Komunikat_Wyświetl( 'Czy wyjść z gry?' + #13 + #13 + 'Das Spiel benden?' + #13 + #13 + 'Quit the game?', 'Potwierdzenie', MB_YESNO + MB_DEFBUTTON2 + MB_ICONQUESTION ) <> IDYES then
  {$ENDIF}


  Kursor_GLAsyncTimer.Enabled := false;


  if not Czy_Pauza() then
    Pauza();

  Schemat__Zwolnij();

  FreeAndNil( schemat_elementy_list );
  FreeAndNil( śnieg_efekt_list );

end;//---//FormClose().

//FormResize().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.FormResize( Sender: TObject );
begin

  if Kamera_Ustaw_CheckBox.Checked then
    Schemat__Kamera_Ustaw();

end;//---//FormResize().

//Animacja__BabyMetal__Kælan_Mikla_MouseMove().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Animacja__BabyMetal__Kælan_Mikla_MouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer );
begin

  kursor_ruch_ostatni_data_czas_g := Now();

  if Screen.Cursor = crNone then
    Screen.Cursor := crDefault;

end;//---//Animacja__BabyMetal__Kælan_Mikla_MouseMove().

//GLCadencer1Progress().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.GLCadencer1Progress( Sender: TObject; const deltaTime, newTime: Double );
var
  i : integer;
begin

  if Gra_GLSceneViewer.Focused then
    begin

      GLUserInterface1.MouseLook();
      GLUserInterface1.MouseUpdate();
      Gra_GLSceneViewer.Invalidate();

    end;
  //---//if Gra_GLSceneViewer.Focused then


  if animacja__etap_g = ae_Schemat_Wczytany then
    Animacja_Parametry_Początkowe_Ustaw()
  else//if animacja__etap_g = ae_Schemat_Wczytany then
  if    ( animacja__etap_g = ae_Schemat_Przygotowany )
    //and (  MilliSecondsBetween( Now(), animacja__etap__czas_zmiany_ostatniej_g ) > schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_milisekundy  ) then
    and (  Czas_Między_W_Milisekundach( animacja__etap__czas_milisekundy_i, true ) > schemat_ustawienia_r_g.animacja__oczekiwanie_do_rozpoczęcia_milisekundy  ) then
    begin

      Rozbłyski__Losowanie_Przygotuj();
      Schemat__Losowanie_Przygotuj();

      animacja__etap_g := ae_Schemat_Animowany;
      //animacja__etap__czas_zmiany_ostatniej_g := Now();
      animacja__etap__czas_milisekundy_i := Czas_Teraz_W_Milisekundach();
      Animacja_Etap_Informacja();

      animacja__krok_czas_milisekundy_i := 0;
      losowanie__elementu__ostatnie_czas_milisekundy_i := Czas_Teraz_W_Milisekundach();
      wiatr_czas_sekundy_i := Czas_Teraz_W_Sekundach();

    end;
  //---//if    ( animacja__etap_g = ae_Schemat_Przygotowany ) (...)


  if animacja__etap_g = ae_Schemat_Animowany then
    begin

      Schemat__Losuj();
      Animuj( deltaTime );
      Rozbłyski__Losuj();
      Wiatr_Śnieg__Losuj();

    end;
  //---//if animacja__etap_g = ae_Schemat_Animowany then


  if    ( animacja__etap_g = ae_Animacja_Zakończona )
    and (
             ( schemat_ustawienia_r_g.animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy < 0 )
          //or (  MilliSecondsBetween( Now(), animacja__etap__czas_zmiany_ostatniej_g ) <= schemat_ustawienia_r_g.animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy  )
          or (  Czas_Między_W_Milisekundach( animacja__etap__czas_milisekundy_i, true ) > schemat_ustawienia_r_g.animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy  )
        ) then
    begin

      Rozbłyski__Losuj();
      Wiatr_Śnieg__Losuj();

    end;
  //---//if    ( animacja__etap_g = ae_Animacja_Zakończona ) (...)


  if    ( animacja__etap_g = ae_Animacja_Zakończona )
    and ( schemat_ustawienia_r_g.animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy >= 0 )
    //and (  MilliSecondsBetween( Now(), animacja__etap__czas_zmiany_ostatniej_g ) > schemat_ustawienia_r_g.animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy  )
    and (  Czas_Między_W_Milisekundach( animacja__etap__czas_milisekundy_i, true ) > schemat_ustawienia_r_g.animacja__wyłączenie_efektu_śniegu_po_zakończeniu_animacji_milisekundy  )
    and ( śnieg_efekt_list.Count > 0 )
    and ( not TŚnieg_Efekt(śnieg_efekt_list[ 0 ]).efekt_gl_fire_fx_manager.Disabled ) then
    for i := 0 to śnieg_efekt_list.Count - 1 do
      TŚnieg_Efekt(śnieg_efekt_list[ i ]).efekt_gl_fire_fx_manager.Disabled := true;


  if Falowanie_CheckBox.Checked then
    Falowanie( deltaTime );


  if Gra_GLSceneViewer.Focused then
    Kamera_Ruch( deltaTime );

end;//---//GLCadencer1Progress().

//Gra_GLSceneViewerClick().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Gra_GLSceneViewerClick( Sender: TObject );
begin

  Gra_GLSceneViewer.SetFocus();

end;//---//Gra_GLSceneViewerClick().

//Gra_GLSceneViewerMouseMove().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Gra_GLSceneViewerMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer );
begin

  if    ( Czy_Pauza() )
    and ( Self.Active )
    and ( Gra_GLSceneViewer.Focused ) then
    begin

      GLUserInterface1.MouseLook();
      GLUserInterface1.MouseUpdate();
      Gra_GLSceneViewer.Invalidate();

    end;
  //---//if    ( Czy_Pauza() ) (...)


  Animacja__BabyMetal__Kælan_Mikla_MouseMove( Sender, Shift, X, Y );

end;//---//Gra_GLSceneViewerMouseMove().

//Gra_GLSceneViewerKeyDown().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Gra_GLSceneViewerKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState );
begin

  if IsKeyDown( VK_ESCAPE ) then
    begin

      Close();
      Exit; // Potwierdzenie pytania Enterem wyzwala funkcjonalność dla klawisza Enter.

    end;
  //---//if IsKeyDown( VK_ESCAPE ) then


  if IsKeyDown( VK_ADD ) then
    Gra_Współczynnik_Prędkości_Zmień( 1 )
  else
  if IsKeyDown( VK_SUBTRACT ) then
    Gra_Współczynnik_Prędkości_Zmień( -1 )
  else
  if IsKeyDown( VK_MULTIPLY ) then
    Gra_Współczynnik_Prędkości_Zmień( 0 );


  if IsKeyDown( VK_DELETE ) then
    begin

      Informacja_Ekranowa_Wyświetl( 'Przerwij' );
      Przerwij_Wczytywanie_Schematu_BitBtnClick( Sender );

    end;
  //---//if IsKeyDown( VK_F2 ) then


  if IsKeyDown( VK_END ) then
    begin

      if Animacja_Rodzaj_RadioGroup.ItemIndex < Animacja_Rodzaj_RadioGroup.Items.Count - 1 then
        begin

          Animacja_Rodzaj_RadioGroup.ItemIndex := Animacja_Rodzaj_RadioGroup.ItemIndex + 1;
          Informacja_Ekranowa_Wyświetl( Animacja_Rodzaj_RadioGroup.Items[ Animacja_Rodzaj_RadioGroup.ItemIndex ] );

        end;
      //---//if Animacja_Rodzaj_RadioGroup.ItemIndex < Animacja_Rodzaj_RadioGroup.Items.Count - 1 then

    end;
  //---//if IsKeyDown( VK_END ) then


  if IsKeyDown( VK_F2 ) then
    begin

      Informacja_Ekranowa_Wyświetl( 'Schemat' );
      Schemat__Odśwież();

    end;
  //---//if IsKeyDown( VK_F2 ) then


  if IsKeyDown( VK_F3 ) then
    begin

      Informacja_Ekranowa_Wyświetl( 'Ustawienia' );
      Schemat__Ustawienia_Odśwież();

    end;
  //---//if IsKeyDown( VK_F3 ) then


  if IsKeyDown( VK_F5 ) then
    begin

      Informacja_Ekranowa_Wyświetl( 'Start' );
      Start_BitBtnClick( Sender );

    end;
  //---//if IsKeyDown( VK_F5 ) then


  if IsKeyDown( VK_F8 ) then
    begin

      Informacja_Ekranowa_Wyświetl( 'Stop' );
      Stop_BitBtnClick( Sender );

    end;
  //---//if IsKeyDown( VK_F8 ) then


  if IsKeyDown( VK_F11 ) then
    begin

      if PageControl1.Width <> 200 then
        PageControl1.Width := 200
      else//if PageControl1.Width <> 200 then
        PageControl1.Width := 1; // 1. Gdy równe 0 to po schowaniu nie da się rozwinąć poprzez Splitter.

      if not Opcje_Splitter.Visible then
        Opcje_Splitter.Visible := true;


      if Kamera_Ustaw_CheckBox.Checked then
        Schemat__Kamera_Ustaw();

    end;
  //---//if IsKeyDown( VK_F12 ) then


  if IsKeyDown( VK_F12 ) then
    begin

      if PageControl1.Width <> 200 then
        PageControl1.Width := 200
      else//if PageControl1.Width <> 200 then
        PageControl1.Width := 0; // 1. Gdy równe 0 to po schowaniu nie da się rozwinąć poprzez Splitter.

      Opcje_Splitter.Visible := PageControl1.Width > 0;


      if Kamera_Ustaw_CheckBox.Checked then
        Schemat__Kamera_Ustaw();

    end;
  //---//if IsKeyDown( VK_F12 ) then


  if IsKeyDown( VK_HOME ) then
    begin

      if Animacja_Rodzaj_RadioGroup.ItemIndex > 0 then
        begin

          Animacja_Rodzaj_RadioGroup.ItemIndex := Animacja_Rodzaj_RadioGroup.ItemIndex - 1;
          Informacja_Ekranowa_Wyświetl( Animacja_Rodzaj_RadioGroup.Items[ Animacja_Rodzaj_RadioGroup.ItemIndex ] );

        end;
      //---//if Animacja_Rodzaj_RadioGroup.ItemIndex > 0 then

    end;
  //---//if IsKeyDown( VK_HOME ) then


  if IsKeyDown( VK_NEXT ) then
    begin

      if Schematy_ComboBox.ItemIndex < Schematy_ComboBox.Items.Count - 1 then
        begin

          Schematy_ComboBox.ItemIndex := Schematy_ComboBox.ItemIndex + 1;
          Schematy_ComboBoxChange( Sender ); // Samo się nie wywołuje.
          Informacja_Ekranowa_Wyświetl( Schematy_ComboBox.Text );

        end;
      //---//if Schematy_ComboBox.ItemIndex < Schematy_ComboBox.Items.Count - 1 then

    end;
  //---//if IsKeyDown( VK_NEXT ) then


  if IsKeyDown( VK_PRIOR ) then
    begin

      if Schematy_ComboBox.ItemIndex > 0 then
        begin

          Schematy_ComboBox.ItemIndex := Schematy_ComboBox.ItemIndex - 1;
          Schematy_ComboBoxChange( Sender ); // Samo się nie wywołuje.
          Informacja_Ekranowa_Wyświetl( Schematy_ComboBox.Text );

        end;
      //---//if Schematy_ComboBox.ItemIndex > 0 then

    end;
  //---//if IsKeyDown( VK_PRIOR ) then


  if    (  IsKeyDown( VK_RETURN )  ) // W GLCadencer1Progress() nie działa podczas pauzy.
    and (  IsKeyDown( VK_MENU )  ) then // Alt.
    begin

      // Pełny ekran.

      if Self.BorderStyle <> bsNone then
        begin

          // Pełny ekran.

          // Po ustawieniu pełnego ekranu mogą znikać elementy położone na formie (jak panel), które nie są wyrównywane do boków okna..

          Self.BorderStyle := bsNone;

          if Self.WindowState = wsMaximized then
            Self.WindowState := wsNormal; // Zmaksymalizowane okno czasami nie zasłania paska start.

          Self.WindowState := wsMaximized;

        end
      else//if Self.BorderStyle <> bsNone then
        begin

          // Normalny ekran.

          Self.BorderStyle := bsSizeable;
          Self.WindowState := wsNormal;

        end;
      //---//if Self.BorderStyle <> bsNone then


      //if Kamera_Ustaw_CheckBox.Checked then
      //  Schemat__Kamera_Ustaw();

    end;
  //---//if    (  IsKeyDown( VK_RETURN )  ) (...)


  if    (  IsKeyDown( VK_RETURN )  )
    and (  IsKeyDown( VK_SHIFT )  ) then
    begin

      // Pełny ekran.

      if Self.WindowState <> wsMaximized then
        begin

          // Pełny ekran.

          Self.WindowState := wsMaximized;

        end
      else//if Self.BorderStyle <> bsNone then
        begin

          // Normalny ekran.

          Self.WindowState := wsNormal;

        end;
      //---//if Self.BorderStyle <> bsNone then


      if Self.BorderStyle <> bsSizeable then
        Self.BorderStyle := bsSizeable;


      //if Kamera_Ustaw_CheckBox.Checked then
      //  Schemat__Kamera_Ustaw();

    end;
  //---//if    (  IsKeyDown( VK_RETURN )  ) (...)


  if IsKeyDown( VK_SPACE ) then
    begin

      GLUserInterface1.MouseLookActive := not GLUserInterface1.MouseLookActive;

      if GLUserInterface1.MouseLookActive then
        Informacja_Ekranowa_Wyświetl( '+ mysz' )
      else//if GLUserInterface1.MouseLookActive then
        Informacja_Ekranowa_Wyświetl( '- mysz' );

    end;
  //---//if IsKeyDown( VK_SPACE ) then


  if IsKeyDown( 'I' ) then
    begin

      Informacja_Ekranowa_CheckBox.Checked := not Informacja_Ekranowa_CheckBox.Checked;
      Informacja_Ekranowa_Wyświetl( 'Informacja ekranowa' );

    end;
  //---//if IsKeyDown( 'I' ) then


  if IsKeyDown( 'K' ) then
    begin

      Schemat__Kamera_Ustaw();

    end;
  //---//if IsKeyDown( 'K' ) then


  if    (  IsKeyDown( 'K' )  )
    and (  IsKeyDown( VK_CONTROL )  ) then
    begin

      Kamera_Ustaw_CheckBox.Checked := not Kamera_Ustaw_CheckBox.Checked;

      if Kamera_Ustaw_CheckBox.Checked then
        Informacja_Ekranowa_Wyświetl( '+ ustaw kamerę' )
      else//if Kamera_Ustaw_CheckBox.Checked then
        Informacja_Ekranowa_Wyświetl( '- ustaw kamerę' );

    end;
  //---//if    (  IsKeyDown( 'K' )  ) (...)


  if    (  IsKeyDown( 'K' )  )
    and (  IsKeyDown( VK_SHIFT )  ) then
    begin

      Gra_GLCamera.ResetRotations();
      Gra_GLCamera.Direction.Z := -1;

      Gra_GLCamera.Position.SetPoint( 0, 0, 10 );

    end;
  //---//if    (  IsKeyDown( 'K' )  ) (...)


  if IsKeyDown( 'M' ) then
    Falowanie_CheckBox.Checked := not Falowanie_CheckBox.Checked;


  if   (  IsKeyDown( 'P' )  ) // Pauza podczas wyłączania przeskakuje widokiem kamery gdy obracanie myszą jest włączone.
    or (  IsKeyDown( VK_PAUSE )  ) then
    begin

      Pauza();

      if Czy_Pauza() then
        Informacja_Ekranowa_Wyświetl( '+ pauza' )
      else//if Czy_Pauza() then
        Informacja_Ekranowa_Wyświetl( '- pauza' );

    end;
  //---//if   (  IsKeyDown( 'P' )  ) (...)


  if IsKeyDown( '/' ) then
    Pomoc_BitBtnClick( Sender );



  if Czy_Pauza() then // Gdy pauza jest aktywna.
    Kamera_Ruch( 0.03 );

end;//---//Gra_GLSceneViewerKeyDown().

//PageControl1Resize().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.PageControl1Resize( Sender: TObject );
begin

  if    ( PageControl1.Width <= 1 )
    and ( Pasek_Postępu_Wyświetlaj_CheckBox.Checked )
    and ( ProgressBar1.Parent <> Self ) then
    begin

      //ProgressBar1.Parent := Self; // Zgłasza dziwne błędy.
      ProgressBar1.Parent := Gra_GLSceneViewer;

      ProgressBar1__Widoczność_Ustaw( false );

    end
  else//if    ( PageControl1.Width <= 1 ) (...)
  if    ( PageControl1.Width > 1 )
    and ( ProgressBar1.Parent <> Opcje_TabSheet ) then
    begin

      ProgressBar1.Parent := Opcje_TabSheet;
      ProgressBar1.Visible := true;
      ProgressBar1__Widoczność_Splitter.Visible := false;

      ProgressBar1.Align := alTop;
      ProgressBar1.Align := alBottom;

      Animacja_Etap_Label.Align := alTop;
      Animacja_Etap_Label.Align := alBottom;

    end;
  //---//if    ( PageControl1.Width > 1 ) (...)

end;//---//PageControl1Resize().

//Falowanie_CheckBoxClick().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Falowanie_CheckBoxClick( Sender: TObject );
begin

  if not Falowanie_CheckBox.Checked then
    begin

      Informacja_Ekranowa_Wyświetl( '- falowanie' );

      Falowanie( 0 );

    end
  else//if not Falowanie_CheckBox.Checked then
    Informacja_Ekranowa_Wyświetl( '+ falowanie' );

end;//---//Falowanie_CheckBoxClick().

//Informacja_Ekranowa_TimerTimer().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Informacja_Ekranowa_TimerTimer( Sender: TObject );
begin

  //Informacja_Ekranowa_GLAsyncTimer.Enabled := false;
  Informacja_Ekranowa_Timer.Enabled := false;

  Informacja_Ekranowa_GLHUDText.Visible := false;
  Informacja_Ekranowa_GLHUDSprite.Visible := false;
  Informacja_Ekranowa_GLHUDText.Text := '';

end;//---//Informacja_Ekranowa_TimerTimer().

//Kursor_GLAsyncTimerTimer().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Kursor_GLAsyncTimerTimer( Sender: TObject );
var
  punkt : TPoint;
begin

  punkt := Mouse.CursorPos;
  punkt := ScreenToClient( punkt );

  if    ( Screen.Cursor = crDefault )
    and ( punkt.X - 3 < Gra_GLSceneViewer.Width )
    //and (  SecondsBetween( Now(), kursor_ruch_ostatni_data_czas_g ) > 3  ) then
    and (
             (
                   ( Self.WindowState = wsMaximized )
               and (  SecondsBetween( Now(), kursor_ruch_ostatni_data_czas_g ) > 1  )
             )
          or (  SecondsBetween( Now(), kursor_ruch_ostatni_data_czas_g ) > 3  )
        ) then
    Screen.Cursor := crNone;

end;//---//Kursor_GLAsyncTimerTimer().

//Schematy_ComboBoxChange().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Schematy_ComboBoxChange( Sender: TObject );
begin

  //if    (   Pos(  animacja__rodzaj__zalecana__nazwa__BabyMetal_c, AnsiLowerCase( Schematy_ComboBox.Text )  ) > 0   )
  //  and ( Animacja_Rodzaj_RadioGroup.ItemIndex <> 0 ) then // BabyMetal.
  //  Animacja_Rodzaj_RadioGroup.ItemIndex := 0 // BabyMetal.
  //else//if    (   Pos(  animacja__rodzaj__zalecana__nazwa__BabyMetal_c, AnsiLowerCase( Schematy_ComboBox.Text )  ) > 0   ) (...)
  //if    (   Pos(  animacja__rodzaj__zalecana__nazwa__Kælan_Mikla_c, AnsiLowerCase( Schematy_ComboBox.Text )  ) > 0   )
  //  and ( Animacja_Rodzaj_RadioGroup.ItemIndex <> 1 ) then // Kælan Mikla.
  //  Animacja_Rodzaj_RadioGroup.ItemIndex := 1; // Kælan Mikla.

end;//---//Schematy_ComboBoxChange().

//Schematy_ComboBoxKeyDown().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Schematy_ComboBoxKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState );
begin

  // Enter.
  if Key = 13 then
    begin

      Key := 0;

      Schemat__Odśwież();

    end;
  //---//if Key = 13 then

end;//---//Schematy_ComboBoxKeyDown().

//Start_BitBtnClick().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Start_BitBtnClick( Sender: TObject );
begin

  if not Czy_Pauza() then
    Pauza();


  if   (  Trim( schemat_wczytany_g ) = ''  )
    or ( schemat_wczytany_g <> Schematy_ComboBox.Text ) then
    begin

      if not Schemat__Wczytaj() then
        Exit;

    end;
  //---//if   (  Trim( schemat_wczytany_g ) = ''  ) (...)



  //if    (
  //          (
  //                 (   Pos(  animacja__rodzaj__zalecana__nazwa__BabyMetal_c, AnsiLowerCase( schemat_ustawienia_r_g.animacja__rodzaj__zalecana_s_su )  ) > 0   )
  //             and ( Animacja_Rodzaj_RadioGroup.ItemIndex <> 0 ) // BabyMetal.
  //           )
  //        or (
  //                 (   Pos(  animacja__rodzaj__zalecana__nazwa__Kælan_Mikla_c, AnsiLowerCase( schemat_ustawienia_r_g.animacja__rodzaj__zalecana_s_su )  ) > 0   )
  //             and ( Animacja_Rodzaj_RadioGroup.ItemIndex <> 1 ) // Kælan Mikla.
  //           )
  //      )
  //  and (  Komunikat_Wyświetl( 'Animacja została przygotowana dla innego rodzaju animacji, czy zmienić rodzaj animacji?' + #13 + #13 + 'Die Animation wurde für eine andere Art von Animation vorbereitet, die Art der Animation ändern?' + #13 + #13 + 'The animation was prepared for a different kind of animation, change the type of animation?', 'Potwierdzenie', MB_YESNO + MB_DEFBUTTON2 + MB_ICONQUESTION ) = IDYES  ) then
  //  begin
  //
  //    if Animacja_Rodzaj_RadioGroup.ItemIndex = 0 then // BabyMetal.
  //      Animacja_Rodzaj_RadioGroup.ItemIndex := 1 // Kælan Mikla.
  //    else//if Animacja_Rodzaj_RadioGroup.ItemIndex = 0 then
  //    if Animacja_Rodzaj_RadioGroup.ItemIndex = 1 then // Kælan Mikla.
  //      Animacja_Rodzaj_RadioGroup.ItemIndex := 0; // BabyMetal.
  //
  //  end;
  ////---//if    ( (...)
  //
  //if schemat_ustawienia_r_g.animacja__rodzaj__zalecana_s_su <> '' then
  //  schemat_ustawienia_r_g.animacja__rodzaj__zalecana_s_su := '';
  //
  //
  //if    ( not falowanie__pytanie_zadane_g )
  //  and (
  //          (
  //                 ( schemat_ustawienia_r_g.falowanie__włączone )
  //             and ( not Falowanie_CheckBox.Checked )
  //           )
  //        or (
  //                 ( not schemat_ustawienia_r_g.falowanie__włączone )
  //             and ( Falowanie_CheckBox.Checked )
  //           )
  //      )
  //  and (  Komunikat_Wyświetl( 'Animacja została przygotowana dla innego ustawienia falowania, czy zmienić ustawienie falowania?' + #13 + #13 + 'Die Animation wurde für eine andere Ripple-Einstellung vorbereitet, möchten Sie die Ripple-Einstellung ändern?' + #13 + #13 + 'The animation has been prepared for a different ripple setting, do you want to change the ripple setting?', 'Potwierdzenie', MB_YESNO + MB_DEFBUTTON2 + MB_ICONQUESTION ) = IDYES  ) then
  //  begin
  //
  //    Falowanie_CheckBox.Checked := schemat_ustawienia_r_g.falowanie__włączone;
  //
  //  end;
  ////---//if    ( not falowanie__pytanie_zadane_g ) (...)
  //
  //if not falowanie__pytanie_zadane_g then
  //  falowanie__pytanie_zadane_g := true;


  if Ustawiena_Według_Schematu_Ustaw_CheckBox.Checked then
    begin

      if    (   Pos(  animacja__rodzaj__zalecana__nazwa__BabyMetal_c, AnsiLowerCase( schemat_ustawienia_r_g.animacja__rodzaj__zalecana_s_su )  ) > 0   )
        and ( Animacja_Rodzaj_RadioGroup.ItemIndex <> 0 ) then // BabyMetal.
        Animacja_Rodzaj_RadioGroup.ItemIndex := 0 // BabyMetal.
      else//if    (   Pos(  animacja__rodzaj__zalecana__nazwa__BabyMetal_c, AnsiLowerCase( schemat_ustawienia_r_g.animacja__rodzaj__zalecana_s_su )  ) > 0   ) (...)
      if     (   Pos(  animacja__rodzaj__zalecana__nazwa__Kælan_Mikla_c, AnsiLowerCase( schemat_ustawienia_r_g.animacja__rodzaj__zalecana_s_su )  ) > 0   )
         and ( Animacja_Rodzaj_RadioGroup.ItemIndex <> 1 ) then // Kælan Mikla.
        Animacja_Rodzaj_RadioGroup.ItemIndex := 1; // Kælan Mikla.


      Falowanie_CheckBox.Checked := schemat_ustawienia_r_g.falowanie__włączone;

    end;
  //---//if Ustawiena_Według_Schematu_Ustaw_CheckBox.Checked then


  if schemat_ustawienia_r_g.animacja__rodzaj_su <> TAnimacja_Rodzaj(Animacja_Rodzaj_RadioGroup.ItemIndex) then
    begin

      schemat_ustawienia_r_g.animacja__rodzaj_su := TAnimacja_Rodzaj(Animacja_Rodzaj_RadioGroup.ItemIndex);

      Schemat__Ustawienia_Odśwież();

    end;
  //---//if schemat_ustawienia_r_g.animacja__rodzaj_su <> TAnimacja_Rodzaj(Animacja_Rodzaj_RadioGroup.ItemIndex) then


  animacja__krok__aktualny_g := animacja__krok__aktualny_kopia_g;
  animacja__etap_g := ae_Schemat_Wczytany;
  //animacja__etap__czas_zmiany_ostatniej_g := Now();
  animacja__etap__czas_milisekundy_i := Czas_Teraz_W_Milisekundach();
  Animacja_Etap_Informacja();


  Animacja_Zakończona_Label.Visible := false;
  //GLCadencer1.CurrentTime := 0; // Przy większych prędkościach gry zablokowuje działanie - przestaje się wywoływać GLCadencer1Progress(). //???


  if Czy_Pauza() then
    Pauza();

end;//---//Start_BitBtnClick().

//Stop_BitBtnClick().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Stop_BitBtnClick( Sender: TObject );
begin

  Schemat__Zwolnij();

end;//---//Stop_BitBtnClick().

//Pauza_ButtonClick().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Pauza_ButtonClick( Sender: TObject );
begin

  Pauza();

end;//---//Pauza_ButtonClick().

//Pomoc_BitBtnClick().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Pomoc_BitBtnClick( Sender: TObject );
var
  czy_pauza_l : boolean;
begin

  czy_pauza_l := Czy_Pauza();

  if not czy_pauza_l then
    Pauza();

  //ShowMessage
  //  (
  //    'Del - przerwij wczytywanie schematu' + #13 +
  //    'Enter + Alt - pełny ekran' + #13 +
  //    'Enter + Shift - zmaksymalizuj okno' + #13 +
  //    'Esc - wyjście' + #13 +
  //    'F2 - odśwież ustawienia schematu (z pliku ini)' + #13 +
  //    'F3 - odśwież ustawienia schematu (z pliku ini)' + #13 +
  //    'F5 - start' + #13 +
  //    'F8 - stop' + #13 +
  //    'F11 - opcje zwiń / rozwiń' + #13 +
  //    'F12 - opcje wyświetl / ukryj' + #13 +
  //    'Home, End - zmiana rodzaju animacji' + #13 +
  //    'I - informacja ekranowa' + #13 +
  //    'K - resetuj kamerę na schemat' + #13 +
  //    'K + Ctrl - resetuj kamerę na punkt 0' + #13 +
  //    'K + Shift - resetuj kamerę na punkt 0' + #13 +
  //    'M - falowanie' + #13 +
  //    'P, Pause Break - pauza' + #13 +
  //    'Page Down - następny schemat' + #13 +
  //    'Page Up - poprzedni schemat' + #13 +
  //    'Spacja - obrót kamery myszą' + #13 +
  //    'W, S, A, D, R, F, Q, E - ruch kamery' + #13 +
  //    '+, -, * - prędkość gry zwiększ, zmniejsz, domyślna' + #13 +
  //    '? - pomoc' + #13
  //  );

  ShowMessage
    (
      'Del - przerwij wczytywanie schematu' + #13 +
        '        beenden Sie das Laden des Schemas [Entfernen]' + #13 +
        '        stop loading the scheme' + #13 +
      'Enter + Alt - pełny ekran <Vollbildschirm> <full screen>' + #13 +
      'Enter + Shift - zmaksymalizuj okno' + #13 +
        '        Fensterstatus maximiert [Eingabetaste + Umschalttaste]' + #13 +
        '        window state maximized' + #13 +
      'Esc - wyjście <Ausgang> <Exit>' + #13 +
      'F2 - przeładuj schemat' + #13 +
        '        laden Sie das Schema neu' + #13 +
        '        refresh the schema' + #13 +
      'F3 - odśwież ustawienia schematu (z pliku ini)' + #13 +
        '        Schemaeinstellungen aktualisieren (aus INI-Datei)' + #13 +
        '        refresh schema settings (from ini file)' + #13 +
      'F5 - start' + #13 +
      'F8 - stop' + #13 +
      'F11 - opcje zwiń / rozwiń' + #13 +
        '        Optionen zuklappen / erweitern' + #13 +
        '        collapse / expand options' + #13 +
      'F12 - opcje wyświetl / ukryj' + #13 +
        '        Optionen ein-/ausblenden' + #13 +
        '        show / hide options' + #13 +
      'Home, End - zmiana rodzaju animacji' + #13 +
        '        Ändern der Art der Animation [Pos1, Ende]' + #13 +
        '        changing the type of animation' + #13 +
      'I - informacja ekranowa' + #13 +
        '        Bildschirminformationen' + #13 +
        '        screen information' + #13 +
      'K - resetuj kamerę na schemat' + #13 +
        '        Kamera zurücksetzen auf das Schema' + #13 +
        '        reset camera to the schema' + #13 +
      'K + Ctrl - automatycznie ustawiaj kamerę' + #13 +
        '        positionieren Sie die Kamera automatisch [K + Strg]' + #13 +
        '        automatically position the camera' + #13 +
      'K + Shift - resetuj kamerę na punkt 0' + #13 +
        '        Kamera zurücksetzen auf Punkt 0 [K + Umschalttaste]' + #13 +
        '        reset camera on point 0' + #13 +
      'M - falowanie <wogen> <waving>' + #13 +
      'P, Pause Break - pauza <Pause> <pause>' + #13 +
      'Page Down - następny schemat' + #13 +
        '        nächstes Schema [Bild ab]' + #13 +
        '        next schema' + #13 +
      'Page Up - poprzedni schemat' + #13 +
        '        vorheriges Schema [Bild auf]' + #13 +
        '        previous scheme' + #13 +
      'Spacja - obrót kamery myszą' + #13 +
        '        Drehung der Kamera mit der Maus [Leerzeichen]' + #13 +
        '        rotation of the camera with the mouse [Space]' + #13 +
      'W, S, A, D, R, F, Q, E - ruch kamery' + #13 +
        '        Kamerabewegung' + #13 +
        '        camera movement' + #13 +
      '+, -, * - prędkość animacji zwiększ, zmniejsz, domyślna' + #13 +
        '        Animations Geschwindigkeit erhöhen, verringern, Standard' + #13 +
        '        animation speed increase, decrease, default' + #13 +
      '? - pomoc <Hilfe> <help>' + #13
    );

  if not czy_pauza_l then
    Pauza();

end;//---//Pomoc_BitBtnClick().

//Przerwij_Wczytywanie_Schematu_BitBtnClick().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Przerwij_Wczytywanie_Schematu_BitBtnClick( Sender: TObject );
begin

  if trwa__wczytywanie_schematu_g then
    begin

      if not przerwij_wczytywanie_schematu_g then
        przerwij_wczytywanie_schematu_g := true;

      if not Czy_Pauza() then
        Pauza();

    end;
  //---//if trwa__wczytywanie_schematu_g then

end;//---//Przerwij_Wczytywanie_Schematu_BitBtnClick().

//Konwerter_Obrazów__Obraz_Adres__Szukaj_ButtonClick().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Konwerter_Obrazów__Obraz_Adres__Szukaj_ButtonClick( Sender: TObject );
begin

  if Konwerter_Obrazów__OpenDialog.Execute() then
    Konwerter_Obrazów__Obraz_Adres_Edit.Text := Konwerter_Obrazów__OpenDialog.FileName;

end;//---//Konwerter_Obrazów__Obraz_Adres__Szukaj_ButtonClick().

//Konwerter_Obrazów__Obraz_Wczytaj_ButtonClick().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Konwerter_Obrazów__Obraz_Wczytaj_ButtonClick( Sender: TObject );
var
  zts : string;
  obrazek_jpg : TJPEGImage; // uses JPEG.
  obrazek_png : TPngImage; // uses pngimage.
  obrazek_gif : TGIFImage; // uses GIFImg.
  zt_image : TImage;
begin

  if not FileExists( Konwerter_Obrazów__Obraz_Adres_Edit.Text ) then
    begin

      Komunikat_Wyświetl( 'Nie odnaleziono pliku:' + #13 + Konwerter_Obrazów__Obraz_Adres_Edit.Text + '.' + #13 + #13 + #13 + 'Datei nicht gefunden.' + #13 + #13 + 'File not found.', 'Informacja', MB_OK + MB_ICONEXCLAMATION );
      Exit;

    end;
  //---//if not FileExists( Konwerter_Obrazów__Obraz_Adres_Edit.Text ) then


  Konwerter_Obrazów__Obraz_Image.Picture := nil; // Czyści rysunek.


  zts := ExtractFileExt( Konwerter_Obrazów__Obraz_Adres_Edit.Text );

  Screen.Cursor := crHourGlass;

  if Pos(  'png', AnsiLowerCase( zts )  ) > 0 then
    begin

      obrazek_png := TPngImage.Create();
      obrazek_png.LoadFromFile( Konwerter_Obrazów__Obraz_Adres_Edit.Text );
      Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Assign( obrazek_png );
      obrazek_png.Free();

    end
  else//if Pos(  'png', AnsiLowerCase( zts )  ) > 0 then
  if   (   Pos(  'jpg', AnsiLowerCase( zts )  ) > 0   )
    or (   Pos(  'jpeg', AnsiLowerCase( zts )  ) > 0   ) then
    begin

      obrazek_jpg := TJPEGImage.Create();
      obrazek_jpg.LoadFromFile( Konwerter_Obrazów__Obraz_Adres_Edit.Text );
      Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Assign( obrazek_jpg );
      obrazek_jpg.Free();

    end
  else//if   (   Pos(  'jpg', AnsiLowerCase( zts )  ) > 0   ) (...)
  if Pos(  'gif', AnsiLowerCase( zts )  ) > 0 then
    begin

      obrazek_gif := TGIFImage.Create();
      obrazek_gif.LoadFromFile( Konwerter_Obrazów__Obraz_Adres_Edit.Text );
      Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Assign( obrazek_gif );
      obrazek_gif.Free();

    end
  else//if Pos(  'gif', AnsiLowerCase( zts )  ) > 0 then
  if   (   Pos(  'tif', AnsiLowerCase( zts )  ) > 0   )
    or (   Pos(  'tiff', AnsiLowerCase( zts )  ) > 0   ) then
    begin

      zt_image := TImage.Create( Application );
      zt_image.Picture.LoadFromFile( Konwerter_Obrazów__Obraz_Adres_Edit.Text );

      Konwerter_Obrazów__Obraz_Image.Picture := nil;
      Konwerter_Obrazów__Obraz_Image.Picture.Bitmap := nil;
      Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Height := zt_image.Picture.Height;
      Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Width := zt_image.Picture.Width;
      Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Canvas.Draw( 0, 0, zt_image.Picture.Graphic );

      FreeAndNil( zt_image );

    end
  else//if   (   Pos(  'tif', AnsiLowerCase( zts )  ) > 0   ) (...)
  if Pos(  'bmp', AnsiLowerCase( zts )  ) > 0 then
    begin

      Konwerter_Obrazów__Obraz_Image.Picture.LoadFromFile( Konwerter_Obrazów__Obraz_Adres_Edit.Text );

    end
  else//if Pos(  'bmp', AnsiLowerCase( zts )  ) > 0 then
    try
      Konwerter_Obrazów__Obraz_Image.Picture.LoadFromFile( Konwerter_Obrazów__Obraz_Adres_Edit.Text );
    except
      on E : Exception do
        Komunikat_Wyświetl( 'Błąd:' + #13 + E.Message + ' ' + IntToStr( E.HelpContext ) + '.' + #13 + #13 + #13 + 'Fehler.' + #13 + #13 + 'Error.', 'Informacja', MB_OK + MB_ICONEXCLAMATION );
    end;
    //---//try


  if    ( not Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Empty )
    and ( Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.PixelFormat <> pf24bit ) then
    Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.PixelFormat := pf24bit;


  Screen.Cursor := crDefault;

end;//---//Konwerter_Obrazów__Obraz_Wczytaj_ButtonClick().

//Konwerter_Obrazów__Obraz_Zapisz_ButtonClick().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Konwerter_Obrazów__Obraz_Zapisz_ButtonClick( Sender: TObject );
type
  TRGBTripleArray = array[ 0..32767 ] of TRGBTriple;
  PRGBTripleArray = ^TRGBTripleArray;
var
  i,
  j,
  próg,
  wartość_min,
  wartość_max
    : integer;
  zts_1,
  zts_2
    : string;
  Row :  PRGBTripleArray;
  zt_string_list : TStringList;
begin

  if Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Empty then
    begin

      Komunikat_Wyświetl( 'Należy wczytać obrazek.' + #13 + #13 + #13 + 'Sie müssen das Bild laden.' + #13 + #13 + 'You need to load the picture.', 'Informacja', MB_OK + MB_ICONEXCLAMATION );
      Exit;

    end;
  //---//if Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Empty then


  if Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.PixelFormat <> pf24bit then
    begin

      Komunikat_Wyświetl( 'Obrazek powinien być formatu 24 bit.' + #13 + #13 + #13 + 'Das Bild sollte im 24-Bit-Format vorliegen.' + #13 + #13 + 'The image should be 24 bit format.', 'Informacja', MB_OK + MB_ICONEXCLAMATION );

    end;
  //---//if Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Empty then


  for i := 0 to Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Height - 1 do
    begin

      Row := Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Scanline[ i ];

      for j := 0 to Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Width - 1 do
        begin

          Row[ j ].rgbtRed := Round(  ( Row[ j ].rgbtRed + Row[ j ].rgbtGreen + Row[ j ].rgbtBlue ) / 3  );
          Row[ j ].rgbtGreen := Row[ j ].rgbtRed;
          Row[ j ].rgbtBlue := Row[ j ].rgbtRed;
          //Row[ j ].rgbtGreen := 0;
          //Row[ j ].rgbtBlue := 0;


          if    ( i = 0 )
            and ( j = 0 ) then
            begin

              wartość_min := Row[ j ].rgbtRed;
              wartość_max := Row[ j ].rgbtRed;

            end
          else//if    ( i = 0 ) (...)
            begin

              if wartość_min > Row[ j ].rgbtRed then
                wartość_min := Row[ j ].rgbtRed;

              if wartość_max < Row[ j ].rgbtRed then
                wartość_max := Row[ j ].rgbtRed;

            end;
          //---//if    ( i = 0 ) (...)

        end;
      //---//for j := 0 to Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Width - 1 do

    end;
  //---//for i := 0 to Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Height - 1 do


  próg := Round(  ( wartość_min + wartość_max ) * 0.5  );

  zt_string_list := TStringList.Create();

  for i := 0 to Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Height - 1 do
    begin

      zts_1 := '';

      Row := Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Scanline[ i ];

      for j := 0 to Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Width - 1 do
        begin

          if Row[ j ].rgbtRed >= próg then
            begin

              Row[ j ].rgbtRed := 255;
              zts_1 := zts_1 + ' ';

            end
          else//if Row[ j ].rgbtRed >= próg then
            begin

              Row[ j ].rgbtRed := 0;
              zts_1 := zts_1 + '1';

            end;
          //---//if Row[ j ].rgbtRed >= próg then


          Row[ j ].rgbtGreen := Row[ j ].rgbtRed;
          Row[ j ].rgbtBlue := Row[ j ].rgbtRed;
          //Row[ j ].rgbtGreen := 0;
          //Row[ j ].rgbtBlue := 0;

        end;
      //---//for j := 0 to Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Width - 1 do

      zt_string_list.Add( zts_1 );

    end;
  //---//for i := 0 to Konwerter_Obrazów__Obraz_Image.Picture.Bitmap.Height - 1 do


  j := 0; // Tutaj tymczasowo jako sprawdzenie czy zapisano schemat do pliku.


  if   ( Sender = nil )
    or (
             ( Sender <> nil )
         and ( TComponent(Sender).Name <> Konwerter_Obrazów__Obraz_Konwertuj_Button.Name )
       ) then
    begin

      zts_1 := System.IOUtils.TPath.GetFileNameWithoutExtension( Konwerter_Obrazów__Obraz_Adres_Edit.Text ); // Nazwa pliku bez rozszerzenia -> 'nazwa'. // uses System.IOUtils.

      if zts_1 = plik_ini_wzorcowy_nazwa_c then
        zts_1 := zts_1 + ' 1';

      zts_1 := ExtractFilePath( Application.ExeName ) + schematy_katalog_nazwa_c + '\' + zts_1;

      zts_2 := '';
      i := 0;

      while ( i <  10 )
        and (  FileExists( zts_1 + zts_2 + '.txt' )  ) do
        begin

          inc( i );

          Sleep( 300 );

          DateTimeToString( zts_2, 'yyyy mm dd hh mm ss', Now() );
          zts_2 := ' ' + zts_2;

        end;
      //---//while ( i <  10 ) (...)


      zts_1 := zts_1 + zts_2 + '.txt';

      if not FileExists( zts_1 ) then
        begin

          zt_string_list.SaveToFile( zts_1 );

          j := 1;

        end
      else//if not FileExists( zts_1 ) then
        Komunikat_Wyświetl( 'Nie udało się zapisać pliku.' + #13 + #13 + #13 + 'Die Datei konnte nicht gespeichert werden.' + #13 + #13 + 'Failed to save the file.', 'Informacja', MB_OK + MB_ICONEXCLAMATION );

    end;
  //---//if   ( Sender = nil ) (...)


  FreeAndNil( zt_string_list );


  Konwerter_Obrazów__Obraz_Image.Invalidate();


  if j = 1 then
    begin

      Schemat__Lista_Wczytaj();


      zts_2 := System.IOUtils.TPath.GetFileNameWithoutExtension( zts_1 ); // Nazwa pliku bez rozszerzenia -> 'nazwa'. // uses System.IOUtils.


      if Trim( zts_2 ) <> '' then
        for i := Schematy_ComboBox.Items.Count - 1 downto 0 do
          if Schematy_ComboBox.Items[ i ] = zts_2 then
            begin

              Schematy_ComboBox.ItemIndex := i;
              Break;

            end;
          //---//if Schematy_ComboBox.Items[ i ] = zts_2 then


      Komunikat_Wyświetl( 'Zapisano plik:' + #13 + zts_2 + '.txt.' + #13 + #13 + #13 + 'Datei gespeichert.' + #13 + #13 + 'File saved.', 'Informacja', MB_OK + MB_ICONINFORMATION );

    end;
  //---//if j = 1 then

end;//---//Konwerter_Obrazów__Obraz_Zapisz_ButtonClick().

//Gra_Współczynnik_Prędkości__Zmniejsz_ButtonClick().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Gra_Współczynnik_Prędkości__Zmniejsz_ButtonClick( Sender: TObject );
begin

  Gra_Współczynnik_Prędkości_Zmień( -1 );

end;//---//Gra_Współczynnik_Prędkości__Zmniejsz_ButtonClick().

//Gra_Współczynnik_Prędkości__Domyślny_ButtonClick().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Gra_Współczynnik_Prędkości__Domyślny_ButtonClick( Sender: TObject );
begin

  Gra_Współczynnik_Prędkości_Zmień( 0 );

end;//---//Gra_Współczynnik_Prędkości__Domyślny_ButtonClick().

//Gra_Współczynnik_Prędkości__Zwiększ_ButtonClick().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.Gra_Współczynnik_Prędkości__Zwiększ_ButtonClick( Sender: TObject );
begin

  Gra_Współczynnik_Prędkości_Zmień( 1 );

end;//---//Gra_Współczynnik_Prędkości__Zwiększ_ButtonClick().

//LinkLabelLinkClick().
procedure TAnimacja__BabyMetal__Kaelan_Mikla__Form.LinkLabelLinkClick( Sender: TObject; const Link: string; LinkType: TSysLinkType );
var
  zts : string;
begin

  if Sender <> nil then
    begin

      if TComponent(Sender).Name = BabyMetal_LinkLabel.Name then
        zts := 'www.babymetal.jp'
      else//if TComponent(Sender).Name = BabyMetal_LinkLabel.Name then
      if TComponent(Sender).Name = Kælan_Mikla_LinkLabel.Name then
        zts := 'www.kaelanmikla.com'
      else//if TComponent(Sender).Name = Kælan_Mikla_LinkLabel.Name then
        zts := '';

      if Trim( zts ) <> '' then
        ShellExecuteW( 0, 'Open', PWideChar(zts), nil, nil, SW_SHOWDEFAULT );

    end;
  //---//if Sender <> nil then

end;//---//LinkLabelLinkClick().

end.
