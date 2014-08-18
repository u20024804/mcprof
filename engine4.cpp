#include "globals.h"
#include "shadow.h"
#include "engine4.h"
#include "commatrix.h"
#include "objects.h"

extern Objects objTable;        // main object table
extern CallStackType CallStack; // main call stack

// all calls to a single func, index is call no
typedef vector<Call> AllCalls2OneFtnType;

// all calls to all functions, index is the funcID
typedef map<u16,AllCalls2OneFtnType> AllCalls2AllFtnsType;

AllCalls2AllFtnsType AllCalls;

Call* currCall; // pointer to current call
/*
whenever a func is entered, a new call is created
This pointer then points to that new call, hence
it is not required to determine the right Call
on read/write access
*/

static u64 GlobalCallSeqNo=0;

void SetCurrCall(string& fname)
{
    int funcid = Name2ID[fname];
    D2ECHO("Setting currCall for " << FUNC(funcid) );

    auto it = AllCalls.find(funcid);
    if( it == AllCalls.end() )
    {
        AllCalls[funcid] = AllCalls2OneFtnType();
    }

    Call newCall;
    AllCalls[funcid].push_back(newCall); // add a new call
    currCall = &( AllCalls[funcid].back() );

    //set callpath of currCall by traversing call stack
    currCall->CallPath = CallStack;
    currCall->SeqNo = GlobalCallSeqNo++;
    
}

void RecordWriteEngine4(uptr addr, int size)
{
    FtnNo prod = CallStack.top();

    D2ECHO("Recording Write:  " << VAR(size) << FUNC(prod) << ADDR(addr));
    int objid = objTable.GetID(addr);
    D2ECHO( ADDR(addr) << " " << ID2Name[objid] << "(" << objid << ")" );

    // TODO check weather we need to some thing special for unknown objects
//     if(objid != UnknownID)
//     {
//     }

    currCall->Writes[objid]+=size;
    for(int i=0; i<size; i++)
    {
        SetProducer(prod, addr+i);
    }
}

void RecordReadEngine4(uptr addr, int size)
{
//     FtnNo cons = CallStack.top();
    D2ECHO("Recording Read " << VAR(size) << FUNC(cons) << ADDR(addr) << dec);

    int objid = objTable.GetID(addr);
    D2ECHO( ADDR(addr) << " " << ID2Name[objid] << "(" << objid << ")" );
    currCall->Reads[objid]+=size;

    //     FtnNo prod;
    //TODO do we need to record the prod to obj, and obj to cons
    // as separate entities ?
}

// print a single call to a single function
void PrintCall(Call& call)
{
    ECHO("Call Seq No : " << call.SeqNo);
    call.CallPath.print();
    for ( auto& readPair : call.Reads)
    {
        u16 oid = readPair.first;
        ECHO("Reads from " << ID2Name[oid] << " : " << readPair.second );
    }

    for ( auto& writePair : call.Writes)
    {
        u16 oid = writePair.first;
        ECHO("Writes to " << ID2Name[oid] << " : " << writePair.second );
    }
}

// print all calls to a single function
void PrintCalls(AllCalls2OneFtnType& calls)
{
    int totalCalls = calls.size();   
    ECHO("Total Calls : " << totalCalls);
    int cno=0;
    for ( auto& call : calls)
    {
        ECHO("Call No : " << cno);
        PrintCall(call);
        cno++;
    }
}

// print all call to all functions
void PrintAllCalls()
{
    ECHO("Printing All Calls");
    for ( auto& callpair :AllCalls)
    {
        u16 fid = callpair.first;
        ECHO("Printing Calls to " << ID2Name[fid]);
        PrintCalls(callpair.second);
    }
}
