// Windows 형태의 thread를 만드는 코드

#include <conio.h>
#include <iostream.h>
#include <windows.h>

DWORD WINAPI ThreadFunc (LPVOID Param) {
    ThreadParam* tp = (ThreadParam*)Param;

    // 한 번 출력하고 Sleep.. 한 번 출력하고 Sleep... 
    for (int i = 0; i < 10; i++)
    {
        cout << endl;
        cout << "Thread " << tp->id << ":" << i << endl;
        Sleep(tp->sleeptime);  // 여기서의 Sleep은 scheduling을 요청하는 것. 나는 Ready Queue로 내려가서 쉴래, 나 아닌 다른 애 실행시켜도 돼.
    }
    return 0;
}

typedef struct stThreadParam {
    int id;
    int sleeptime;
} ThreadParam;

int main(){
    HANDLE hTread[4];
    DWORD ThreadID[4];
    ThreadParam tp[4];
    for (int i = 0; i < 4; i++)
    {
        tp[i].id = i;
        tp[i].sleeptime = i*200;
        hTread[i] = CreateThread(NULL, 0, ThreadFunc, &tp[i], 0, &ThreadID[i]);
            /*
                ThreadFunc을 수행할 thread 4개 생성. (4개마다 thread id는 다르다.)
                main에 thread 1개. ThreadFunc에 thread 4개. 총 5개.
            */
    }
    
    WaitForMultipleObjects(4, hTread, TRUE, INFINITE); // ThreadFunc을 수행하는 thread 4개가 다 끝날 때까지 기다린다.
    getch();

    return 0;
    
}