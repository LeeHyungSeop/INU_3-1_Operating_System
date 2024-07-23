/*
    reference : https://ehpub.co.kr/7-%ec%b2%ab-%eb%b2%88%ec%a7%b8-%ec%8b%a4%ec%8a%b5-%eb%8f%84%ed%98%95-%ec%9d%b4%eb%8f%99-%ec%8b%9c%ed%82%a4%ea%b8%b0/
    reference : https://pang92.tistory.com/241

*/

#include <Windows.h>
#define MY_DRAW_WND (TEXT("하키 게임"))
#define WINDOW_LENGTH 800   // 띄워지는 window창의 X축 길이
#define WINDOW_HEIGHT 500   // 띄워지는 window창의 Y축 길이

#define STICK_LENGTH 10     // com, user 둘 다 Stick의 X축 길이를 같게
#define STICK_HEIGHT 80     // com, user 둘 다 Stick의 Y축 길이를 같게
#define STICK_OFFSET 10     // user stick의 offset

#define BALL_RADIUS 5       // Ball의 반지름
#define BALL_OFFSETX 3      // Ball의 초기 offset x
#define BALL_OFFSETY 3      // Ball의 초기 offset y

int level = 1;  // level = 1 -> 초보, 2 -> 중급, 3 -> 상급
int stage = 1;
int save = 3;
BOOL end_flag = FALSE;
BOOL gameStart = FALSE;

// 함수 선언
LRESULT CALLBACK MyWndProc(HWND hWnd, UINT iMessage, WPARAM wParam, LPARAM lParam);
void RegWindowClass();
void MessageLoop();
void DrawStick(HWND hWnd, HDC hdc, HPEN hPen, HBRUSH hBrush, LPRECT prt);
void DrawBall(HWND hWnd, HDC hdc, HPEN hPen, HBRUSH hBrush);
void OnPaint(HWND hWnd);
void OnDestroy(HWND hWnd);
DWORD WINAPI ballThreadUpDown(LPVOID lpParameter);
DWORD WINAPI comThreadUpDown(LPVOID lpParameter);
DWORD WINAPI userThreadUpDown(LPVOID lpParameter);
void DrawDiagram(HWND hWnd, HDC hdc, HPEN hPen, HBRUSH hBrush, LPRECT prt); //그리기 작업


typedef struct RECTANGULAR { // reference : https://pang92.tistory.com/241
    RECT pos; // left : 사각형 왼쪽 위 모서리에 대한 x좌표
    // top : 사각형 왼쪽 위 모서리에 대한 y좌표
    // right : 사각형 오른쪽 아래 모서리에 있는 x좌표
    // bottom : 사각형 오른쪽 아래 모서리에 대한 y좌표
    float offset;
}STICK;

typedef struct CIRCLE {
    LONG left;
    LONG top;
    LONG right;
    LONG bottom;
    int offsetX;
    int offsetY;
}BALL;

// user stick 초기화
STICK user = { {WINDOW_LENGTH - 35, WINDOW_HEIGHT / 2 - STICK_HEIGHT / 2, WINDOW_LENGTH - 35 + STICK_LENGTH,  WINDOW_HEIGHT / 2 + STICK_HEIGHT / 2}, STICK_OFFSET };
// com stick 초기화
STICK com = { {15, WINDOW_HEIGHT / 2 - STICK_HEIGHT * 3, 15 + STICK_LENGTH, WINDOW_HEIGHT / 2 + STICK_HEIGHT * 3}, 5 };
// ball 초기화 (나중에 사용자의 level 선택에 따라 ball.offset을 바꿔줄 것이다)
BALL ball = { WINDOW_LENGTH / 2 - BALL_RADIUS, WINDOW_HEIGHT / 2 - BALL_RADIUS, WINDOW_LENGTH / 2 + BALL_RADIUS, WINDOW_HEIGHT / 2 + BALL_RADIUS, BALL_OFFSETX, BALL_OFFSETY };

HANDLE userThread = NULL;  // user thread
HANDLE comThread = NULL;   // com thread
HANDLE ballThread = NULL;  // ball thread 

void RegWindowClass()
{
    WNDCLASS wndclass = { 0 };
    wndclass.hbrBackground = (HBRUSH)GetStockObject(WHITE_BRUSH); // window창 배경색 설정
    wndclass.hCursor = LoadCursor(0, IDC_ARROW);                  // 마우스 커서 핸들
    wndclass.hIcon = LoadIcon(0, IDI_APPLICATION);                // 아이콘 핸들
    wndclass.hInstance = GetModuleHandle(0);                      // 자신 모듈의 인스턴스 핸들
    wndclass.lpfnWndProc = MyWndProc;                             // 윈도우 콜백 프로시저
    wndclass.lpszClassName = MY_DRAW_WND;                         // 클래스 이름 - 클래스 구분자
    wndclass.style = CS_DBLCLKS;                                  // 클래스 종류

    RegisterClass(&wndclass); // 윈도우 클래스 등록
}


// 초기 화면 그려주는 함수
void initialWindow(HWND hWnd)
{
    // 하키 게임 Title
    HDC hdc_game = GetDC(hWnd);
    TextOut(hdc_game, WINDOW_LENGTH / 2 - 130, WINDOW_HEIGHT / 2 - 150, TEXT(":: Hockey Game / 201901766 이형섭 HW02 ::"), lstrlen(TEXT(":: Hockey Game / 201901766 이형섭 HW02 ::")));
    ReleaseDC(hdc_game, hdc_game);

    // 난이도 선택 설명 문구
    HDC hdc_explain = GetDC(hWnd);
    TextOut(hdc_explain, WINDOW_LENGTH / 2 - 180, WINDOW_HEIGHT / 2 - 50, TEXT("[난이도 선택] 숫자 키패드 1,2 3 중에 하나를 입력해주세요."), lstrlen(TEXT("[난이도 선택] 숫자 키패드 1,2 3 중에 하나를 입력해주세요.")));
    ReleaseDC(hdc_explain, hdc_explain);

    // 초급
    HDC hdc_low = GetDC(hWnd);
    TextOut(hdc_low, WINDOW_LENGTH / 2 - 100, WINDOW_HEIGHT / 2, TEXT("1. LEVEL1 (Computer Bar 느림)"), lstrlen(TEXT("1. LEVEL1 (Computer Bar 느림)")));
    ReleaseDC(hdc_low, hdc_low);
    // 중급
    HDC hdc_mid = GetDC(hWnd);
    TextOut(hdc_mid, WINDOW_LENGTH / 2 - 100, WINDOW_HEIGHT / 2 + 50, TEXT("2. LEVEL2 (Computer Bar 보통)"), lstrlen(TEXT("2. LEVEL2 (Computer Bar 보통)")));
    ReleaseDC(hdc_mid, hdc_mid);
    // 고급
    HDC hdc_high = GetDC(hWnd);
    TextOut(hdc_mid, WINDOW_LENGTH / 2 - 100, WINDOW_HEIGHT / 2 + 100, TEXT("3. LEVEL3 (Computer Bar 빠름)"), lstrlen(TEXT("3. LEVEL3 (Computer Bar 빠름)")));
    ReleaseDC(hdc_high, hdc_high);
}

INT APIENTRY WinMain(HINSTANCE hIns, HINSTANCE hPrev, LPSTR cmd, INT nShow)
{
    RegWindowClass(); //윈도우 클래스 속성 설정 및 등록

    //윈도우 인스턴스 생성
    HWND hWnd = CreateWindow(
        MY_DRAW_WND,         // 클래스 이름
        TEXT("Hockey Game / 201901766 이형섭 HW02"),   // window name
        WS_OVERLAPPEDWINDOW, // window style
        0, 0, WINDOW_LENGTH, WINDOW_HEIGHT,// window창이 띄워질 laptop화면의 x축 위치, y축 위치, window창의 x축 길이, y축 길이
        0,      // 부모 윈도우 핸들  (HWND hWndParent)
        0,      // 메뉴 핸들 (HMENU hMenu)
        hIns,   // 인스턴스 핸들 (HANDLE hInstance)
        0);     // 생성 시 전달 인자 (LPVOID lpParam)


    ShowWindow(hWnd, nShow); // 윈도우 인스턴스 시각화, SW_SHOW(시각화), SW_HIDE(비시각화)  
    initialWindow(hWnd);

    // 초기화면을 띄우고나서 1, 2, 3 입력을 대기한다
    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);

        // 사용자가 1, 2, 3 중에 입력한 경우 해당 값을 level 변수에 저장하고 thread를 생성
        if (msg.message == WM_CHAR) {
            if (msg.wParam == '1') {
                level = 1;
            }
            else if (msg.wParam == '2') {
                level = 2;
            }
            else if (msg.wParam == '3') {
                level = 3;
            }
            else { // 1, 2, 3이 아닌 키가 눌리면 gameStart, while문 탈출하지 못하도록
                continue;
            }
            gameStart = TRUE;
            break;
        }
    }

    // com stick 초기화 (사용자가 고른 난이도로 com stick의 속도를 다르게 설정)
    com.offset = level * 5;

    // 공, user, com 각각의 thread 생성
    if (ballThread == NULL) {
        ballThread = CreateThread(NULL, 0, ballThreadUpDown, NULL, 0, 0);
    }
    if (userThread == NULL) {
        userThread = CreateThread(NULL, 0, userThreadUpDown, NULL, 0, 0);
    }
    if (comThread == NULL) {
        comThread = CreateThread(NULL, 0, comThreadUpDown, NULL, 0, 0);
    }

    MessageLoop(); // 메시지 루프
}

void MessageLoop()
{
    MSG Message;
    while (GetMessage(&Message, 0, 0, 0)) // 메시지 루프에서 메시지 꺼냄(WM_QUIT이면 FALSE 반환)
    {
        TranslateMessage(&Message);       // WM_KEYDOWN이고 키가 문자 키일 때 WM_CHAR 발생
        DispatchMessage(&Message);        // 콜백 프로시저가 수행할 수 있게 디스패치 시킴
    }
    // user의 목숨이 0개면 종료해야 하기 때문에 flag를 TRUE로 변경
    if (save == 0) {
        end_flag = TRUE;
    }
}

// ball move 함수
DWORD WINAPI ballThreadUpDown(LPVOID lpParameter) {
    HWND hWnd = (HWND)lpParameter; // hWnd 핸들을 저장

    while (1)
    {
        ball.top += ball.offsetY;
        ball.bottom += ball.offsetY;
        ball.left += ball.offsetX;
        ball.right += ball.offsetX;

        if (ball.top <= 0) {
            ball.top = 0;
            ball.bottom = 2 * BALL_RADIUS;
            ball.offsetY = -1 * ball.offsetY;
        }
        if (ball.bottom >= WINDOW_HEIGHT && ball.offsetY > 0) {
            ball.bottom = WINDOW_HEIGHT;
            ball.top = ball.bottom - (2 * BALL_RADIUS);
            ball.offsetY = -1 * ball.offsetY;
        }
        if (ball.left <= 0) {
            ball.left = 0;
            ball.right = 2 * BALL_RADIUS;
            ball.offsetX = -1 * ball.offsetX;
            stage += 1;  // ball이 왼쪽 벽에 닿아도 stage 증가. 하지만 공 속도는 그대로
        }
        if (ball.right >= WINDOW_LENGTH) {
            ball.left = WINDOW_LENGTH - (2 * BALL_RADIUS);
            ball.right = WINDOW_LENGTH;
            ball.offsetX = -1 * ball.offsetX;
            save -= 1;  // 오른쪽 벽에 튕기면, user가 못 받은 것이니까 save--
        }

        // ball이 com stick에 닿으면, 튕김 (속도 증가. 등차 수열식으로..)
        if (ball.offsetX < 0 &&
            ball.left <= com.pos.right &&
            ball.bottom >= com.pos.top &&
            ball.top <= com.pos.bottom)
        {
            ball.offsetX = -ball.offsetX + BALL_OFFSETX / 2;
            if (ball.offsetY > 0) {
                ball.offsetY += BALL_OFFSETY / 3;
            }
            else {
                ball.offsetY -= BALL_OFFSETY / 3;
            }
            ball.left = com.pos.right; // 공을 스틱에서 밀어내기
            ball.right = ball.left + 2 * BALL_RADIUS;
            stage += 1;  // stage 증가
        }

        // ball이 user stick에 닿으면, 튕김
        if ((ball.right >= user.pos.left) && (ball.bottom >= user.pos.top) && (ball.top <= user.pos.bottom)) {
            ball.offsetX = -1 * ball.offsetX;
        }

        InvalidateRect(hWnd, NULL, TRUE); // 이동한 위치로 업데이트
        Sleep(10);
    }
}

// com stick move 함수
DWORD WINAPI comThreadUpDown(LPVOID lpParameter)
{
    HWND hWnd = (HWND)lpParameter; // hWnd 핸들을 저장

    while (1)
    {
        com.pos.top += com.offset;
        com.pos.bottom += com.offset;

        if (com.pos.top <= 0) {
            com.pos.top = 0;
            com.pos.bottom = 3 * STICK_HEIGHT;
            if (com.offset < 0) {
                com.offset = -1 * com.offset;
            }
        }
        else if (com.pos.bottom >= WINDOW_HEIGHT) {
            com.pos.top = WINDOW_HEIGHT - 3 * STICK_HEIGHT;
            com.pos.bottom = WINDOW_HEIGHT;
            if (com.offset > 0) {
                com.offset = -1 * com.offset;
            }
        }
        InvalidateRect(hWnd, NULL, TRUE); // 이동한 위치로 업데이트
        Sleep(10);
    }
}

// user stick move 함수
DWORD WINAPI userThreadUpDown(LPVOID lpParameter)
{
    HWND hWnd = (HWND)lpParameter; // hWnd 핸들을 저장
    while (1)
    {
        // https://m.blog.naver.com/pkk1113/90155000817
        // 만약 위쪽 방향키가 눌렸다면, 이동
        if (GetAsyncKeyState(VK_UP) & 0x8000)
        {
            if (user.pos.top > 0) {
                user.pos.top -= user.offset;
                user.pos.bottom -= user.offset;
            }
            InvalidateRect(hWnd, NULL, TRUE); // up한 위치로 이동시킴. (update)
        }
        // 만약 아래 방향키가 눌렸다면, 이동
        else if (GetAsyncKeyState(VK_DOWN) & 0x8000)
        {
            if (user.pos.bottom + STICK_HEIGHT / 2 < WINDOW_HEIGHT) {
                user.pos.top += user.offset;
                user.pos.bottom += user.offset;
            }
            InvalidateRect(hWnd, NULL, TRUE); // down한 위치로 이동시킴. (update)
        }
        Sleep(20);
    }
}

LRESULT CALLBACK MyWndProc(HWND hWnd, UINT iMessage, WPARAM wParam, LPARAM lParam)
{
    switch (iMessage)
    {
    case WM_CLOSE: // 창 닫기 버튼 누르면, 종료
        DestroyWindow(hWnd);
        break;
    case WM_DESTROY:
        PostQuitMessage(0);
        break;
    case WM_PAINT:
        OnPaint(hWnd);
        break;
    default:
        return DefWindowProc(hWnd, iMessage, wParam, lParam);
    }
    return 0;
}
// com, user stick 그리기
void DrawStick(HWND hWnd, HDC hdc, LPRECT prt, HBRUSH hBrush)
{
    HBRUSH oBrush; // DC에 기존 선택 브러쉬 핸들 기억할 변수    
    oBrush = (HBRUSH)SelectObject(hdc, hBrush); // 입력 인자로 전달받은 브러쉬를 DC에 선택

    Rectangle(hdc, prt->left, prt->top, prt->right, prt->bottom); // stick 그리기

    SelectObject(hdc, oBrush); // 기존 선택 브러쉬를 DC에 선택
}

// ball 그리기
void DrawBall(HWND hWnd, HDC hdc, HBRUSH hBrush)
{
    HBRUSH oBrush; // DC에 기존 선택 브러쉬 핸들 기억할 변수    
    oBrush = (HBRUSH)SelectObject(hdc, hBrush); // 입력 인자로 전달받은 브러쉬를 DC에 선택

    Ellipse(hdc, ball.left, ball.top, ball.right, ball.bottom); // ball 그리기

    SelectObject(hdc, oBrush); // 기존 선택 브러쉬를 DC에 선택
}

// WM_PAINT 메시지 처리기
void OnPaint(HWND hWnd)
{
    if (gameStart == TRUE) {
        PAINTSTRUCT ps;
        HDC hdc = BeginPaint(hWnd, &ps); // DC 발급

        DrawStick(hWnd, hdc, &com, WHITE_BRUSH);  // com
        DrawStick(hWnd, hdc, &user, WHITE_BRUSH); // user
        DrawBall(hWnd, hdc, WHITE_BRUSH);
        TCHAR stage_level_text[256] = TEXT("");
        wsprintf(stage_level_text, TEXT("Stage : %d (Level : %d)"), stage, level);
        TextOut(hdc, WINDOW_LENGTH / 2 - 50, 50, stage_level_text, lstrlen(stage_level_text));
        TCHAR save_text[256] = TEXT("");
        wsprintf(save_text, TEXT("Save : %d"), save);
        TextOut(hdc, WINDOW_LENGTH - 100, 50, save_text, lstrlen(save_text));


        if (end_flag == TRUE || save == 0) {
            TCHAR end_text[256] = TEXT("");
            wsprintf(end_text, TEXT("GAME OVER!!!  FINAL Stage : %d"), stage);
            TextOut(hdc, WINDOW_LENGTH / 2 - 100, WINDOW_HEIGHT / 2, end_text, lstrlen(end_text));

            Sleep(5000);

            PostQuitMessage(0); // 메시지 큐에 WM_QUIT 메시지를 붙임
            return 0; // 종료
        }
        EndPaint(hWnd, &ps); // DC 해제
    }
}

// WM_DESTROY 메시지 처리기
void OnDestroy(HWND hWnd)
{
    PostQuitMessage(0); // 메시지 큐에 WM_QUIT 메시지를 붙임
}