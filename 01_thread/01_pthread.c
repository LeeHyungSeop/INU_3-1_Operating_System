// pthread 형태의 thread를 만드는 코드

#include <stdio.h>
#include <pthread.h> // library 형태

int thread_args[3] = {0, 1, 2};

int global_count = 0;

void* Thread(void* arg) { // return type이 void* : return값은 주소를 가지지만, 값이 없다. 
                          // 일반적인 변수는 값을 가지므로 void type을 못 쓰지만, 함수에만 붙을 수 있다. 

    int i;

    for (i = 0; i < 5; i++){
        global_count += 1;
        printf("thread %d : %dth iteration, global count is %d\n", *(int*)arg, i, global_count);
    }

    printf("thread %d : thread를 종료합니다.\n", *(int*)arg);
    pthread_exit(0); // thread를 끝내겠다.
    printf("thread는 종료되었기 때문에 이 출력을 하지 않는다.\n");
}

int main(void){
    int i ;
    pthread_t threads[3]; // pthread_t 구조체 변수 3개 생성

    for (i = 0; i < 3; i++){
        printf("Thread Num %d Create!!\n", i);
        pthread_create(&threads[i], NULL, (void *(*) (void *)) Thread, &thread_args[i]); 
            /*
                "pthread_create" -> pthread.h library에 있는 함수이다. pthread형태의 thread를 만들어주는 함수.
                "(void *(*) (void *)) Thread" -> Thread 함수를 thread로 만들겠다. 함수의 인자로는 "thread_args"를 쓰겠다.

                이 process 내에서 main함수와 Thread함수를 독립적으로 실행시키겠다.
                main함수에서 thread 함수를 호출하지 않겠다.

                main함수에서 동작하는 thread 1개(printf 3번). Thread 함수를 알아서 실행시키는 thread 3개(printf 15번). -> 이 program에 thread는 총 4개(총printf 18번)
                    총 printf가 18번이 나올 것인데, 어떻게 나올지는 모른다.
                    어떻게 우선순위를 가지는지? 어떻게 스케줄링 될지? 언제 context switch될지?에 따라 다르다.
                    심지어 어떤 이유로 printf()가 잘려 나올 수 있다.
                
            */
    }

    printf("이제 main thread를 종료합니다.\n");
    pthread_exit(0);

    printf("여기는 main thread를 종료한 이후이기 때문에 출력되지 않을 것입니다.\n");
    printf("9999999999999999\n");

    
    return 0;
}

/*
    하나의 program 내에 동작은 분리되어 할 수 있도록 -> thread로 만든다

*/