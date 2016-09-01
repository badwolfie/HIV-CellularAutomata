#include <winbgim.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct cell{
        int t,c;
        }CELL;

main()
{
    initwindow(500,500);
    int i,j,e=1,inf,NA,NB,rep;
    CELL **control,**aux;
    srand(time(NULL));
    
    control=(CELL**)malloc(500*sizeof(CELL*));
    aux=(CELL**)malloc(500*sizeof(CELL*));
    
    for(i=0;i<500;i++)
    {
         control[i]=(CELL*)malloc(500*sizeof(CELL));
         aux[i]=(CELL*)malloc(500*sizeof(CELL));
    }
    
    for(i=0;i<500;i++)
    for(j=0;j<500;j++)
    {
         inf=rand()%100;
         if(inf==1||inf==2||inf==3||inf==4||inf==5)
         {
              control[i][j].c=2;
              aux[i][j].c=2;
         }
         else
         {
             control[i][j].c=1;
             aux[i][j].c=1;
         }
         control[i][j].t=0;
    }

    while(!kbhit())
    {
            printf("T= %d semana(s)",e);
            for(i=0;i<500;i++)
            {
            for(j=0;j<500;j++)
            {
                 NA=0;
                 NB=0;
                 
                 if(control[(i+499)%500][(j+499)%500].c==2)
                 NA++;
                 if(control[(i+499)%500][j].c==2)
                 NA++;
                 if(control[(i+499)%500][(j+1)%500].c==2)
                 NA++;
                 if(control[i][(j+499)%500].c==2)
                 NA++;
                 if(control[i][(j+1)%500].c==2)
                 NA++;
                 if(control[(i+1)%500][(j+499)%500].c==2)
                 NA++;
                 if(control[(i+1)%500][j].c==2)
                 NA++;
                 if(control[(i+1)%500][(j+1)%500].c==2)
                 NA++;
                      
                 if(control[(i+499)%500][(j+499)%500].c==3)
                 NB++;
                 if(control[(i+499)%500][j].c==3)
                 NB++;
                 if(control[(i+499)%500][(j+1)%500].c==3)
                 NB++;
                 if(control[i][(j+499)%500].c==3)
                 NB++;
                 if(control[i][(j+1)%500].c==3)
                 NB++;
                 if(control[(i+1)%500][(j+499)%500].c==3)
                 NB++;
                 if(control[(i+1)%500][j].c==3)
                 NB++;
                 if(control[(i+1)%500][(j+1)%500].c==3)
                 NB++;
                 
                 switch(control[i][j].c)
                 {
                 case 1:{
                      putpixel(j,i,BLUE);
                      if((NA>=1)||(NB>=4))
                      {
                       aux[i][j].c=2;
                       aux[i][j].t=((control[i][j].t)+1)%5;
                      }
                      break;
                      }
                 case 2:{
                      putpixel(j,i,YELLOW);
                      if(control[i][j].t==4)
                      aux[i][j].c=3;
                      aux[i][j].t=((control[i][j].t)+1)%5;
                      break;
                      }
                 case 3:{
                      putpixel(j,i,GREEN);
                      aux[i][j].c=0;
                      aux[i][j].t=((control[i][j].t)+1)%5;
                      break;
                      }
                 case 0:{
                      putpixel(j,i,RED);
                      rep=rand()%100;
                      if(rep!=1)
                      {
                          inf=rand()%10000;
                          if(inf==1)
                          {
                               aux[i][j].c=2;
                               aux[i][j].t=((control[i][j].t)+1)%5;
                          }
                          else
                          aux[i][j].c=1;
                      }
                      break;
                      }
                 default:break;
                 }
            }
            }
            
            for(i=0;i<500;i++)
            for(j=0;j<500;j++)
            {
                 control[i][j].c=aux[i][j].c;
                 control[i][j].t=aux[i][j].t;
            }
    
    system("cls");
    e++;
    }
    
    while(!kbhit());
    closegraph();
	return 0;
}
