/* Assembler v1.0 designed by Yuvraj Singh for SIC architecture
 * Language: C++ 4.3.2
 * Assembly directive supported:
 */
#include<stdio.h>
#include<stdlib.h>
#include<iostream>
#include<algorithm>
#include<fstream>
#include<cmath>
#include<string.h>
using namespace std;
string optable[12];
string optable1[12];
string symtab[100];
int lloc[1000];
char arr[1000];
int endp;
void change(char ch[])
{
    int i;
    int c;
    for(i=0;i<strlen(ch);i++)
    {
        c=ch[i];
        if(c>=97&&c<=122)
        {
             c=c-32;
             ch[i]=c;
        }

    }
}
void convert(string y)
{
    int j;
    for(j=0;j<y.length();j++)
    {
        arr[j]=y[j];
    }
}
int table[100]={-1};
int counter=0;
int searchoptab(string x)
{

    int i;

    //cout<<"I have started searching for opcode "<<x<<"function\n";
    for(i=0;i<x.length();i++)
    {
        if(isalpha(x[i]))
        toupper(x[i]);

    }
    for(i=0;i<12;i++)
    {
        if(optable[i]==x)
            return i;
    }
    return -1;
}
int searchtab(string x)
{
    int i;
    for(i=0;i<counter;i++)
    {
        if(x==symtab[i])
        return i;
    }
    return -1;
}
void inserttab(string x,int k)
{


    symtab[counter]=x;
    table[counter]=k;
    counter++;
}
int min1(int x,int y)
{
    if(x>y)
        return y;
    return x;
}
int main(int argc, char *argv[])
{
    //label opcode operand
ifstream myfile;
ofstream frieza;
optable[0]="lda";
optable1[0]="00";
optable[1]="sta";
optable1[1]="0C";
optable[2]="ldx";
optable1[2]="04";
optable[3]="stx";
optable1[3]="10";
optable[4]="add";
optable1[4]="18";
optable[5]="sub";
optable1[5]="3A";
optable[6]="comp";
optable1[6]="28";
optable[7]="j";
optable1[7]="3C";
optable[8]="jeq";
optable1[8]="30";
optable[9]="jlt";
optable1[9]="38";
optable[10]="rsub";
optable1[10]="4C";
optable[11]="jgt";
optable1[11]="34";
int lineno=0;
int erropcode[1000]={0};
int errorsymboltab[1000]={0};
int i;
int stadd;
int locctr=0;
int error;
int num=0;
string pname;
int operand_len,lab_len,opcode_len;
myfile.open(argv[1]);//file to be read
frieza.open(argv[2]);//file to be written
string data,label,opcode,operand;
  while(getline(myfile,data))
  {
     label="";
     opcode="";
     operand="";
     if(data[0]!='.'){
     for(i=0;i<8;i++)
     {

         if(data[i]!= ' ')
         {
             label=label+data[i];
         }
     }

     for(i=8;i<min1(16,data.length());i++)
     {
         if(data[i]!=' ')
         {

             opcode=opcode+data[i];


         }

     }

     for(i=16;i<data.length();i++)
     {
         if(data[i]!= ' ')
         {
             operand=operand+data[i];

         }
     }

     if(opcode=="start")
     {
         num=0;
         pname=label;
        // cout<<"Length of operand is "<<operand.length()<<"\n";
         for(i=0;i<operand.length();i++)
         {
             convert(operand);
             //converted the starting address to hex
             num=(int)strtol(arr,NULL,16);
         }
         locctr=num;

         //cout<<"value of locctr initialised at "<<locctr;
         stadd=locctr;
     }
     else
     {

     if(opcode!="end")
     {
         if(label[0]!='.')
         {
             if(!label.empty())
             {   int f;
                 f=searchtab(label);
                 if(f!=-1) //symbol found hence duplicate detected!!!
                 {
                     error=1;
                     errorsymboltab[lineno]=-1;
                    // cout<<"duplicate symbol error";
                 }
                 else
                 {
                     inserttab(label,locctr);
                     //cout<<"Inserted value is
                 }
             }
             int f1;
             f1=searchoptab(opcode);
             if(f1!=-1) //when opcode is in the operand table
             {
                 locctr+=3;



             }
             else
             {


                 if(opcode=="word")
                    locctr+=3;
                 else if(opcode=="resw")
                 {    num=0;
                      for(i=0;i<operand.length();i++)
                          {
                            int x=operand[i]-48;
                            num=num*10+x;
                          }
                       locctr+=3*num;
                 }

                 else if(opcode=="resb")
                 {   num=0;
                     for(i=0;i<operand.length();i++)
                          {
                            int x=operand[i]-48;
                            num=num*10+x;
                          }
                       locctr+=num;
                 }
                 else if(opcode=="byte")
                 {
                    if(operand[0]=='c')
                     {
                         locctr+=operand.length()-3;
                     }
                    else
                    {
                        if(operand[0]=='x')
                            locctr+=(int)(operand.length()-3)*0.5;
                    }
                 }
                 else
                 {
                     erropcode[lineno]=-1;
                 }


             }
         }
     }
     else
     {
         endp=locctr;

     }
  }
     //cout<<"Location counter at line "<<lineno<<"is "<<locctr<<"\n";

         lineno++;

         lloc[lineno]=locctr;


     }
  }
  /*
  for(i=0;i<lineno;i++)
  {
      cout<<lloc[i]<<"\n";
  }
  */
  //End of pass 1


//checking for error generated;
bool e1,e2;
e1=false;
e2=false;
for(i=0;i<lineno;i++)
{
    if(erropcode[i]==-1)
    {
        e1=true;
        frieza<<"!!Invalid opcode at Line no "<<lineno<<"\n";
    }
    if(erropcode[i]==-2)
    {
        e1=true;
        frieza<<"!!Not allowed odd no of bytes in hex data type"<<lineno<<"\n";
    }
}
for(i=0;i<lineno;i++)
{
    if(errorsymboltab[i]==-1)
    {
        e2=true;
        frieza<<"!!Duplicate label at Line no "<<lineno<<"\n";
    }
}

  lineno=0;
  bool pass2=false;
  ifstream myfile1;
  myfile1.open(argv[1]);

  while(getline(myfile1,data)&&!(e1)&&!(e2))
  {    pass2=true;
       label="";
     opcode="";
     operand="";
     if(data[0]!='.')
     {


     for(i=0;i<8;i++)
     {

         if(data[i]!= ' ')
         {
             label=label+data[i];
         }
     }
     for(i=8;i<min1(16,data.length());i++)
     {
         if(data[i]!= ' ')
         {
             opcode=opcode+data[i];
         }
     }
     if(opcode=="end")
     {
         frieza<<"E00";
         itoa(stadd,arr,16);
          change(arr);
         frieza<<arr;
         break;
     }
     for(i=16;i<data.length();i++)
     {
         if(data[i]!= ' ')
         {
             operand=operand+data[i];

         }
     }
     if(opcode=="resw" || opcode=="resb")
     {   //cout<<"continue to be done\n";
          lineno++;
         continue;
     }

     if(opcode=="start")
     {
      int len;
      frieza<<"H";
      len=6-pname.length();
      frieza<<pname;
      for(i=1;i<=len;i++)
      frieza<<" ";
      frieza<<"00";
      itoa(stadd,arr,16);
      change(arr);
      frieza<<arr;
      itoa(endp-stadd,arr,16);
      len=6-strlen(arr);
      for(i=0;i<=len;i++)
      frieza<<"0";
      change(arr);
      frieza<<arr<<"\n";
    }
    else
    {
         frieza<<"T00";
         itoa(lloc[lineno],arr,16);
         change(arr);
         frieza<<arr;
         frieza<<"03";
         if(searchoptab(opcode)!=-1)
         {
              frieza<<optable1[searchoptab(opcode)];
              if(!operand.empty())
              {
                    if(searchtab(operand)!=-1)
                    {
                        itoa(table[searchtab(operand)],arr,16);
                        change(arr);
                        frieza<<arr;
                    }
                    else if(operand.find(",x")!=-1)
                    {
                        operand.resize(operand.length()-2);
                        if(searchtab(operand)!=-1)
                        {
                            int dbz=arr[0];
                            if(dbz>=48 && dbz<54)
                            {
                                dbz=dbz-40;
                                itoa(dbz,arr,16);
                                frieza<<arr[i];
                            }
                            itoa(table[searchtab(operand)],arr,16);
                            change(arr);
                            for(i=1;i<strlen(arr);i++)
                                frieza<<arr[i];
                        }
                    }


              }
              else
              {
                  frieza<<"0000";
              }
         }
         else if(opcode=="byte")
         {
             if(operand[0]=='c')
             {
                 for(i=2;i<operand.length()-1;i++)
                 {
                     int temp;
                     temp=operand[i];
                     itoa(temp,arr,16);
                     change(arr);
                     frieza<<arr;
                 }
             }
             else if(operand[0]=='x')
             {
                  for(i=2;i<operand.length()-1;i++)
                 {
                    frieza<<operand[i];
                 }
             }
         }
         else if(opcode=="word")
         {
             int lg;
             lg=6-operand.length();
             for(i=1;i<=lg;i++)
             {
                 frieza<<"0";
             }
             frieza<<operand;
         }
         frieza<<"\n";
         }


    }
    if(data[0]!='.')
    lineno++;
     }
     myfile1.close();
     frieza.close();
     if(pass2==false)
        frieza<<"!!Assembling aborted due to above errors\n!";

     /*if(pass2==true)
     {   int j;
         //cout<<"hey"<<endl;
         string gohan;
         ifstream myfile3;
         ofstream goku;
          int cnt=0;
        myfile3.open(argv[2]);
        goku.open(argv[2]);
        while(getline(myfile3,gohan))
        {
            //cout<<"hey";
            //cout<<x<<"\n";
            if(cnt!=0)
            {


            for(j=0;j<gohan.length();j++)
            {
                if(isalpha(x[i]))
                {
                    goku<<toupper(x[i])<<"\n"
                }
            }
            }
           cnt++;
        }
     }*/
 // cout<<"starting address "<<sta<<"\n";
 /*
  printf("Optable\n");
  for(i=0;i<12;i++)
    cout<<optable[i]<<optable1[i]<<"\n";
 cout<<"Counter value "<<counter;
  printf("\n\nSymbol Table\n");
  for(i=0;i<counter;i++)
     cout<<symtab[i]<<" "<<table[i]<<" "<<"\n";
*/
     //Pass2 commences

return 0;




}
