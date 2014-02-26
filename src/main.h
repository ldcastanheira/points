
#include "cli.h"

void f_start(int n, char *arg[], const struct cmd_tab *tab);

#define pts_load        {{"load"}             , f_load       , {"<specfile>"}}
#define pts_summary     {{"summary"}          , f_summary    , {""}}
#define pts_select      {{"select"}           , f_select     , {"<project> <view>"}}
#define pts_progress    {{"progress"}         , f_progress   , {""}}
#define pts_todo        {{"todo"}             , f_todo       , {""}}
#define pts_hc          {{"history", "closed"}, f_hc         , {"<number of weeks>"}}
#define pts_hb          {{"history", "buffer"}, f_hb         , {"<number of weeks>"}}
#define pts_show        {{"show"}             , f_show       , {"[screen-parameters]"}}
#define pts_export      {{"export"}           , f_export     , {"<filename> [format] [screen-parameters]"}}
#define pts_addmodule   {{"add", "module"}    , f_addmodule  , {"<filename>"}}
#define pts_execcmd     {{"exec"}             , f_execcmd    , {"<command>"}}

