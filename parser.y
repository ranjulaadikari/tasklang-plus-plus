%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int line_num;
extern int yylex();
void yyerror(const char *s);

/* Circular dependency detection */
#define MAX_TASKS 50
char *task_names[MAX_TASKS];
char *task_deps[MAX_TASKS];
int task_count = 0;

void register_task(char *name);
void register_dependency(char *task, char *dep);
void check_circular_dependencies();
int find_task(char *name);
%}

%union {
    char *str;
}

%token TASK RUN EVERY DAY WEEK ON AT AFTER IF SUCCESS FAILURE DEPENDS LBRACE RBRACE
%token <str> IDENTIFIER STRING TIME DAYNAME

%%

program:
    task_list
    {
        printf("\n--- EXECUTION COMPLETE ---\n");
        check_circular_dependencies();
    }
;

task_list:
    task
  | task_list task
;

task:
    TASK IDENTIFIER LBRACE statement_list RBRACE
    {
        printf("\nExecuting Task: %s\n", $2);
        register_task($2);

        /* print statements collected */
        printf("  [Task '%s' parsed successfully]\n", $2);
        free($2);
    }
;

statement_list:
  | statement_list statement
;

statement:
    run_stmt
  | schedule_stmt
  | dependency_stmt
  | condition_stmt
;

run_stmt:
    RUN STRING
    {
        printf("  Script: %s\n", $2);
        free($2);
    }
;

schedule_stmt:
    EVERY DAY AT TIME
    {
        printf("  Schedule: EVERY DAY AT %s\n", $4);
        free($4);
    }
  | EVERY WEEK ON DAYNAME AT TIME
    {
        printf("  Schedule: EVERY WEEK ON %s AT %s\n", $4, $6);
        free($4);
        free($6);
    }
  | AT TIME
    {
        printf("  Schedule: AT %s\n", $2);
        free($2);
    }
;

dependency_stmt:
    AFTER IDENTIFIER
    {
        printf("  Depends on: %s\n", $2);
        /* dependency registered later via task name */
        free($2);
    }
  | DEPENDS AFTER IDENTIFIER
    {
        printf("  Depends on: %s\n", $3);
        free($3);
    }
;

condition_stmt:
    IF SUCCESS
    {
        printf("  Condition: success\n");
    }
  | IF FAILURE
    {
        printf("  Condition: failure\n");
    }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "\nSyntax Error at line %d: %s\n", line_num, s);
}

void register_task(char *name) {
    if (task_count < MAX_TASKS) {
        task_names[task_count] = strdup(name);
        task_deps[task_count] = NULL;
        task_count++;
    }
}

void register_dependency(char *task, char *dep) {
    for (int i = 0; i < task_count; i++) {
        if (strcmp(task_names[i], task) == 0) {
            task_deps[i] = strdup(dep);
            return;
        }
    }
}

int find_task(char *name) {
    for (int i = 0; i < task_count; i++) {
        if (strcmp(task_names[i], name) == 0) return i;
    }
    return -1;
}

void check_circular_dependencies() {
    printf("\n[Checking for circular dependencies...]\n");
    int found = 0;
    for (int i = 0; i < task_count; i++) {
        if (task_deps[i] != NULL) {
            int dep_idx = find_task(task_deps[i]);
            if (dep_idx != -1 && task_deps[dep_idx] != NULL) {
                if (strcmp(task_deps[dep_idx], task_names[i]) == 0) {
                    fprintf(stderr, "WARNING: Circular dependency detected between '%s' and '%s'!\n",
                            task_names[i], task_names[dep_idx]);
                    found = 1;
                }
            }
        }
    }
    if (!found) printf("[No circular dependencies found.]\n");
}

int main() {
    printf("Parsing TaskLang++ input...\n");
    printf("\n--- EXECUTION START ---\n");
    return yyparse();
}
