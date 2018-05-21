#include "iostream"
using namespace std;
int factroial(int number);
int main()
{
	int a;
	cin>>a;
	cout<<factroial(a)<<endl;
}
int factroial(int number)
{
	if(number==1)
	{
		return 1;
	}
	return (number)*factroial(number-1);
}

