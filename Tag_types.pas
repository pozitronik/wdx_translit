unit tag_types; { Contents of file contplug.pas }

interface


const
      ft_nomorefields=0;
      ft_numeric_32=1;
      ft_numeric_64=2;
      ft_numeric_floating=3;
      ft_date=4;
      ft_time=5;
      ft_boolean=6;
      ft_multiplechoice=7;
      ft_string=8;
      ft_fulltext=9;
      ft_datetime=10;
// for ContentGetValue
      ft_nosuchfield=-1;
      ft_fileerror=-2;
      ft_fieldempty=-3;
      ft_ondemand=-4;
      ft_delayed=0;
      MAX_PATH = 260;
// for ContentSetValue
      ft_setsuccess=0;     // setting of the attribute succeeded
// for ContentGetSupportedFieldFlags
      contflags_edit=1;
      contflags_substsize=2;
      contflags_substdatetime=4;
      contflags_substdate=6;
      contflags_substtime=8;
      contflags_substattributes=10;
      contflags_substattributestr=12;
      contflags_passthrough_size_float=14;
      contflags_substmask=14;
      contflags_fieldedit=16;
// for ContentSendStateInformation
      contst_readnewdir=1;
      contst_refreshpressed=2;
      contst_showhint=4;
      setflags_first_attribute=1;    // First attribute of this file
      setflags_last_attribute=2;     // Last attribute of this file
      setflags_only_date=4;          // Only set the date of the datetime value!

      CONTENT_DELAYIFSLOW=1;  // ContentGetValue called in foreground
      CONTENT_PASSTHROUGH=2;  // If requested via contflags_passthrough_size_float: The size


type tContentDefaultParamStruct=record
      size,
      PluginInterfaceVersionLow,
      PluginInterfaceVersionHi:longint;
      DefaultIniName:array[0..MAX_PATH-1] of char;
    end;

    pContentDefaultParamStruct=^tContentDefaultParamStruct;

type tdateformat=record
       wYear,wMonth,wDay:word;
     end;
     pdateformat=^tdateformat;
type ttimeformat=record
       wHour,wMinute,wSecond:word;
     end;

     ptimeformat=^ttimeformat;


implementation

end.