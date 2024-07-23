/*
    reference : https://ehpub.co.kr/7-%ec%b2%ab-%eb%b2%88%ec%a7%b8-%ec%8b%a4%ec%8a%b5-%eb%8f%84%ed%98%95-%ec%9d%b4%eb%8f%99-%ec%8b%9c%ed%82%a4%ea%b8%b0/
    reference : https://pang92.tistory.com/241

*/

#include <Windows.h>
#define MY_DRAW_WND (TEXT("��Ű ����"))
#define WINDOW_LENGTH 800   // ������� windowâ�� X�� ����
#define WINDOW_HEIGHT 500   // ������� windowâ�� Y�� ����

#define STICK_LENGTH 10     // com, user �� �� Stick�� X�� ���̸� ����
#define STICK_HEIGHT 80     // com, user �� �� Stick�� Y�� ���̸� ����
#define STICK_OFFSET 10     // user stick�� offset

#define BALL_RADIUS 5       // Ball�� ������
#define BALL_OFFSETX 3      // Ball�� �ʱ� offset x
#define BALL_OFFSETY 3      // Ball�� �ʱ� offset y

int level = 1;  // level = 1 -> �ʺ�, 2 -> �߱�, 3 -> ���
int stage = 1;
int save = 3;
BOOL end_flag = FALSE;
BOOL gameStart = FALSE;

// �Լ� ����
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
void DrawDiagram(HWND hWnd, HDC hdc, HPEN hPen, HBRUSH hBrush, LPRECT prt); //�׸��� �۾�


typedef struct RECTANGULAR { // reference : https://pang92.tistory.com/241
    RECT pos; // left : �簢�� ���� �� �𼭸��� ���� x��ǥ
    // top : �簢�� ���� �� �𼭸��� ���� y��ǥ
    // right : �簢�� ������ �Ʒ� �𼭸��� �ִ� x��ǥ
    // bottom : �簢�� ������ �Ʒ� �𼭸��� ���� y��ǥ
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

// user stick �ʱ�ȭ
STICK user = { {WINDOW_LENGTH - 35, WINDOW_HEIGHT / 2 - STICK_HEIGHT / 2, WINDOW_LENGTH - 35 + STICK_LENGTH,  WINDOW_HEIGHT / 2 + STICK_HEIGHT / 2}, STICK_OFFSET };
// com stick �ʱ�ȭ
STICK com = { {15, WINDOW_HEIGHT / 2 - STICK_HEIGHT * 3, 15 + STICK_LENGTH, WINDOW_HEIGHT / 2 + STICK_HEIGHT * 3}, 5 };
// ball �ʱ�ȭ (���߿� ������� level ���ÿ� ���� ball.offset�� �ٲ��� ���̴�)
BALL ball = { WINDOW_LENGTH / 2 - BALL_RADIUS, WINDOW_HEIGHT / 2 - BALL_RADIUS, WINDOW_LENGTH / 2 + BALL_RADIUS, WINDOW_HEIGHT / 2 + BALL_RADIUS, BALL_OFFSETX, BALL_OFFSETY };

HANDLE userThread = NULL;  // user thread
HANDLE comThread = NULL;   // com thread
HANDLE ballThread = NULL;  // ball thread 

void RegWindowClass()
{
    WNDCLASS wndclass = { 0 };
    wndclass.hbrBackground = (HBRUSH)GetStockObject(WHITE_BRUSH); // windowâ ���� ����
    wndclass.hCursor = LoadCursor(0, IDC_ARROW);                  // ���콺 Ŀ�� �ڵ�
    wndclass.hIcon = LoadIcon(0, IDI_APPLICATION);                // ������ �ڵ�
    wndclass.hInstance = GetModuleHandle(0);                      // �ڽ� ����� �ν��Ͻ� �ڵ�
    wndclass.lpfnWndProc = MyWndProc;                             // ������ �ݹ� ���ν���
    wndclass.lpszClassName = MY_DRAW_WND;                         // Ŭ���� �̸� - Ŭ���� ������
    wndclass.style = CS_DBLCLKS;                                  // Ŭ���� ����

    RegisterClass(&wndclass); // ������ Ŭ���� ���
}


// �ʱ� ȭ�� �׷��ִ� �Լ�
void initialWindow(HWND hWnd)
{
    // ��Ű ���� Title
    HDC hdc_game = GetDC(hWnd);
    TextOut(hdc_game, WINDOW_LENGTH / 2 - 130, WINDOW_HEIGHT / 2 - 150, TEXT(":: Hockey Game / 201901766 ������ HW02 ::"), lstrlen(TEXT(":: Hockey Game / 201901766 ������ HW02 ::")));
    ReleaseDC(hdc_game, hdc_game);

    // ���̵� ���� ���� ����
    HDC hdc_explain = GetDC(hWnd);
    TextOut(hdc_explain, WINDOW_LENGTH / 2 - 180, WINDOW_HEIGHT / 2 - 50, TEXT("[���̵� ����] ���� Ű�е� 1,2 3 �߿� �ϳ��� �Է����ּ���."), lstrlen(TEXT("[���̵� ����] ���� Ű�е� 1,2 3 �߿� �ϳ��� �Է����ּ���.")));
    ReleaseDC(hdc_explain, hdc_explain);

    // �ʱ�
    HDC hdc_low = GetDC(hWnd);
    TextOut(hdc_low, WINDOW_LENGTH / 2 - 100, WINDOW_HEIGHT / 2, TEXT("1. LEVEL1 (Computer Bar ����)"), lstrlen(TEXT("1. LEVEL1 (Computer Bar ����)")));
    ReleaseDC(hdc_low, hdc_low);
    // �߱�
    HDC hdc_mid = GetDC(hWnd);
    TextOut(hdc_mid, WINDOW_LENGTH / 2 - 100, WINDOW_HEIGHT / 2 + 50, TEXT("2. LEVEL2 (Computer Bar ����)"), lstrlen(TEXT("2. LEVEL2 (Computer Bar ����)")));
    ReleaseDC(hdc_mid, hdc_mid);
    // ���
    HDC hdc_high = GetDC(hWnd);
    TextOut(hdc_mid, WINDOW_LENGTH / 2 - 100, WINDOW_HEIGHT / 2 + 100, TEXT("3. LEVEL3 (Computer Bar ����)"), lstrlen(TEXT("3. LEVEL3 (Computer Bar ����)")));
    ReleaseDC(hdc_high, hdc_high);
}

INT APIENTRY WinMain(HINSTANCE hIns, HINSTANCE hPrev, LPSTR cmd, INT nShow)
{
    RegWindowClass(); //������ Ŭ���� �Ӽ� ���� �� ���

    //������ �ν��Ͻ� ����
    HWND hWnd = CreateWindow(
        MY_DRAW_WND,         // Ŭ���� �̸�
        TEXT("Hockey Game / 201901766 ������ HW02"),   // window name
        WS_OVERLAPPEDWINDOW, // window style
        0, 0, WINDOW_LENGTH, WINDOW_HEIGHT,// windowâ�� ����� laptopȭ���� x�� ��ġ, y�� ��ġ, windowâ�� x�� ����, y�� ����
        0,      // �θ� ������ �ڵ�  (HWND hWndParent)
        0,      // �޴� �ڵ� (HMENU hMenu)
        hIns,   // �ν��Ͻ� �ڵ� (HANDLE hInstance)
        0);     // ���� �� ���� ���� (LPVOID lpParam)


    ShowWindow(hWnd, nShow); // ������ �ν��Ͻ� �ð�ȭ, SW_SHOW(�ð�ȭ), SW_HIDE(��ð�ȭ)  
    initialWindow(hWnd);

    // �ʱ�ȭ���� ������ 1, 2, 3 �Է��� ����Ѵ�
    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);

        // ����ڰ� 1, 2, 3 �߿� �Է��� ��� �ش� ���� level ������ �����ϰ� thread�� ����
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
            else { // 1, 2, 3�� �ƴ� Ű�� ������ gameStart, while�� Ż������ ���ϵ���
                continue;
            }
            gameStart = TRUE;
            break;
        }
    }

    // com stick �ʱ�ȭ (����ڰ� �� ���̵��� com stick�� �ӵ��� �ٸ��� ����)
    com.offset = level * 5;

    // ��, user, com ������ thread ����
    if (ballThread == NULL) {
        ballThread = CreateThread(NULL, 0, ballThreadUpDown, NULL, 0, 0);
    }
    if (userThread == NULL) {
        userThread = CreateThread(NULL, 0, userThreadUpDown, NULL, 0, 0);
    }
    if (comThread == NULL) {
        comThread = CreateThread(NULL, 0, comThreadUpDown, NULL, 0, 0);
    }

    MessageLoop(); // �޽��� ����
}

void MessageLoop()
{
    MSG Message;
    while (GetMessage(&Message, 0, 0, 0)) // �޽��� �������� �޽��� ����(WM_QUIT�̸� FALSE ��ȯ)
    {
        TranslateMessage(&Message);       // WM_KEYDOWN�̰� Ű�� ���� Ű�� �� WM_CHAR �߻�
        DispatchMessage(&Message);        // �ݹ� ���ν����� ������ �� �ְ� ����ġ ��Ŵ
    }
    // user�� ����� 0���� �����ؾ� �ϱ� ������ flag�� TRUE�� ����
    if (save == 0) {
        end_flag = TRUE;
    }
}

// ball move �Լ�
DWORD WINAPI ballThreadUpDown(LPVOID lpParameter) {
    HWND hWnd = (HWND)lpParameter; // hWnd �ڵ��� ����

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
            stage += 1;  // ball�� ���� ���� ��Ƶ� stage ����. ������ �� �ӵ��� �״��
        }
        if (ball.right >= WINDOW_LENGTH) {
            ball.left = WINDOW_LENGTH - (2 * BALL_RADIUS);
            ball.right = WINDOW_LENGTH;
            ball.offsetX = -1 * ball.offsetX;
            save -= 1;  // ������ ���� ƨ���, user�� �� ���� ���̴ϱ� save--
        }

        // ball�� com stick�� ������, ƨ�� (�ӵ� ����. ���� ����������..)
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
            ball.left = com.pos.right; // ���� ��ƽ���� �о��
            ball.right = ball.left + 2 * BALL_RADIUS;
            stage += 1;  // stage ����
        }

        // ball�� user stick�� ������, ƨ��
        if ((ball.right >= user.pos.left) && (ball.bottom >= user.pos.top) && (ball.top <= user.pos.bottom)) {
            ball.offsetX = -1 * ball.offsetX;
        }

        InvalidateRect(hWnd, NULL, TRUE); // �̵��� ��ġ�� ������Ʈ
        Sleep(10);
    }
}

// com stick move �Լ�
DWORD WINAPI comThreadUpDown(LPVOID lpParameter)
{
    HWND hWnd = (HWND)lpParameter; // hWnd �ڵ��� ����

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
        InvalidateRect(hWnd, NULL, TRUE); // �̵��� ��ġ�� ������Ʈ
        Sleep(10);
    }
}

// user stick move �Լ�
DWORD WINAPI userThreadUpDown(LPVOID lpParameter)
{
    HWND hWnd = (HWND)lpParameter; // hWnd �ڵ��� ����
    while (1)
    {
        // https://m.blog.naver.com/pkk1113/90155000817
        // ���� ���� ����Ű�� ���ȴٸ�, �̵�
        if (GetAsyncKeyState(VK_UP) & 0x8000)
        {
            if (user.pos.top > 0) {
                user.pos.top -= user.offset;
                user.pos.bottom -= user.offset;
            }
            InvalidateRect(hWnd, NULL, TRUE); // up�� ��ġ�� �̵���Ŵ. (update)
        }
        // ���� �Ʒ� ����Ű�� ���ȴٸ�, �̵�
        else if (GetAsyncKeyState(VK_DOWN) & 0x8000)
        {
            if (user.pos.bottom + STICK_HEIGHT / 2 < WINDOW_HEIGHT) {
                user.pos.top += user.offset;
                user.pos.bottom += user.offset;
            }
            InvalidateRect(hWnd, NULL, TRUE); // down�� ��ġ�� �̵���Ŵ. (update)
        }
        Sleep(20);
    }
}

LRESULT CALLBACK MyWndProc(HWND hWnd, UINT iMessage, WPARAM wParam, LPARAM lParam)
{
    switch (iMessage)
    {
    case WM_CLOSE: // â �ݱ� ��ư ������, ����
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
// com, user stick �׸���
void DrawStick(HWND hWnd, HDC hdc, LPRECT prt, HBRUSH hBrush)
{
    HBRUSH oBrush; // DC�� ���� ���� �귯�� �ڵ� ����� ����    
    oBrush = (HBRUSH)SelectObject(hdc, hBrush); // �Է� ���ڷ� ���޹��� �귯���� DC�� ����

    Rectangle(hdc, prt->left, prt->top, prt->right, prt->bottom); // stick �׸���

    SelectObject(hdc, oBrush); // ���� ���� �귯���� DC�� ����
}

// ball �׸���
void DrawBall(HWND hWnd, HDC hdc, HBRUSH hBrush)
{
    HBRUSH oBrush; // DC�� ���� ���� �귯�� �ڵ� ����� ����    
    oBrush = (HBRUSH)SelectObject(hdc, hBrush); // �Է� ���ڷ� ���޹��� �귯���� DC�� ����

    Ellipse(hdc, ball.left, ball.top, ball.right, ball.bottom); // ball �׸���

    SelectObject(hdc, oBrush); // ���� ���� �귯���� DC�� ����
}

// WM_PAINT �޽��� ó����
void OnPaint(HWND hWnd)
{
    if (gameStart == TRUE) {
        PAINTSTRUCT ps;
        HDC hdc = BeginPaint(hWnd, &ps); // DC �߱�

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

            PostQuitMessage(0); // �޽��� ť�� WM_QUIT �޽����� ����
            return 0; // ����
        }
        EndPaint(hWnd, &ps); // DC ����
    }
}

// WM_DESTROY �޽��� ó����
void OnDestroy(HWND hWnd)
{
    PostQuitMessage(0); // �޽��� ť�� WM_QUIT �޽����� ����
}