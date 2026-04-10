# --- Master Configuration ---

EX_DIRS := $(sort $(wildcard ex??))
IS_GIT  := $(shell [ -d .git ] && echo "yes" || echo "no")

# --- Remote URLs ---

GIT_URL   := git@github.com:bababxxm/cpp07.git
INTRA_URL := git@vogsphere.42bangkok.com:vogsphere/intra-uuid-d9965845-13ad-4cbb-9455-9912c1f97258-7192116-sklaokli

# --- Style Configurations ---

# Your VS Code Settings (Default)
STYLE_DEFAULT := "{BasedOnStyle: Google, UseTab: ForIndentation, IndentWidth: 4, TabWidth: 4, ColumnLimit: 100, PointerAlignment: Left, DerivePointerAlignment: false, BreakBeforeBraces: Attach, AccessModifierOffset: -4, SortIncludes: true, IncludeBlocks: Merge, AllowShortFunctionsOnASingleLine: Inline, AllowShortBlocksOnASingleLine: Always, BreakConstructorInitializers: BeforeComma}"
STYLE_GOOGLE  := "Google"
STYLE_LLVM    := "LLVM"

# Style selection logic
ifeq ($(style), google)
    CHOSEN_STYLE := $(STYLE_GOOGLE)
else ifeq ($(style), llvm)
    CHOSEN_STYLE := $(STYLE_LLVM)
else
    CHOSEN_STYLE := $(STYLE_DEFAULT)
endif

# --- Colors ---

BLUE    := \033[1;34m
GREEN   := \033[1;32m
YELLOW  := \033[1;33m
RED     := \033[1;31m
PURPLE  := \033[1;35m
CYAN    := \033[1;36m
RESET   := \033[0m

# --- Generator Content ---

define GITIGNORE_CONTENT
*.o
*.d
*.pdf
.DS_Store
.DS_Store?
*.dSYM/
.vscode/
.idea/
*.swp
*.swo

a.out
bin/
endef

define MAKEFILE_CONTENT
NAME        :=  a.out
SRC_DIR     :=  src
OBJ_DIR     :=  bin
INC_DIR     :=  include
FILES       :=  main.cpp $$(addsuffix .cpp, $$(CLASS))
SRC         :=  $$(addprefix $$(SRC_DIR)/, $$(FILES))
OBJ         :=  $$(addprefix $$(OBJ_DIR)/, $$(FILES:%.cpp=%.o))
HEADERS     :=  $$(addprefix $$(INC_DIR)/, $$(addsuffix .hpp, $$(HEADER))) \
                $$(addprefix $$(INC_DIR)/, $$(addsuffix .hpp, $$(CLASS)))
CXX         :=  c++
WFLAGS      :=  -Wall -Wextra -Werror
STDFLAGS    :=  -std=c++98 -pedantic
INCLUDE     :=  -I$$(INC_DIR)
COMPILE     :=  $$(CXX) $$(WFLAGS) $$(STDFLAGS) $$(INCLUDE)

all: $$(NAME)
$$(OBJ_DIR):
	@mkdir -p $$(OBJ_DIR)
$$(OBJ_DIR)/%.o: $$(SRC_DIR)/%.cpp $$(HEADERS) | $$(OBJ_DIR)
	@$$(COMPILE) -c $$< -o $$@
$$(NAME): $$(OBJ)
	@$$(COMPILE) $$(OBJ) -o $$(NAME)
clean:
	@rm -rf $$(OBJ_DIR)
fclean: clean
	@rm -f $$(NAME)
re: fclean all
.PHONY: all clean fclean re
endef

define MAIN_CONTENT
#include <iostream>

int main() {
    std::cout << "Exercise initialized successfully!" << std::endl;
    return 0;
}
endef

export GITIGNORE_CONTENT
export MAKEFILE_CONTENT
export MAIN_CONTENT

# --- Master Logic ---

.DEFAULT_GOAL := help

help:
	@echo "$(CYAN)Available commands for Master Makefile:$(RESET)"
	@echo ""
	@echo "$(BLUE)Build & Test:$(RESET)"
	@echo "  $(GREEN)make all$(RESET)            - Compile all exercises"
	@echo "  $(GREEN)make test$(RESET)           - Compile and run tests for all exercises"
	@echo "  $(GREEN)make clean$(RESET)          - Remove object files"
	@echo "  $(GREEN)make fclean$(RESET)         - Remove objects and executables"
	@echo "  $(GREEN)make re$(RESET)             - Recompile everything"
	@echo ""
	@echo "$(BLUE)Formatting:$(RESET)"
	@echo "  $(GREEN)make format$(RESET)         - Format code using your default style"
	@echo "  $(GREEN)make format style=X$(RESET) - Format using $(YELLOW)google$(RESET) or $(YELLOW)llvm$(RESET) styles"
	@echo ""
	@echo "$(BLUE)Repository Management:$(RESET)"
	@echo "  $(GREEN)make git$(RESET)            - Initialize git and .gitignore"
	@echo "  $(GREEN)make github$(RESET)         - Push current branch to GitHub main"
	@echo "  $(GREEN)make 42$(RESET)             - Push current branch to 42 Vogsphere master"
	@echo "  $(GREEN)make both$(RESET)           - Push to both GitHub and 42"
	@echo "  $(GREEN)make status$(RESET)         - Show remote repository status"
	@echo ""
	@echo "$(BLUE)Generators:$(RESET)"
	@echo "  $(GREEN)make create ex=XX$(RESET)   - Generate folder structure for an exercise"
	@echo ""

all:
	@if [ -z "$(EX_DIRS)" ]; then \
		echo "$(YELLOW)No exercises found. Use 'make create ex=00'$(RESET)"; \
	else \
		for dir in $(EX_DIRS); do \
			echo "$(BLUE)Compiling $$dir...$(RESET)"; \
			$(MAKE) -C $$dir --no-print-directory -s; \
		done; \
		echo "$(GREEN)All exercises finished successfully!$(RESET)"; \
	fi

clean:
	@for dir in $(EX_DIRS); do $(MAKE) clean -C $$dir --no-print-directory -s; done

fclean:
	@for dir in $(EX_DIRS); do $(MAKE) fclean -C $$dir --no-print-directory -s; done

re: fclean all

test:
	@for dir in $(EX_DIRS); do \
		$(MAKE) -C $$dir --no-print-directory -s; \
		echo "$(YELLOW)Running $$dir tests...$(RESET)"; \
		./$$dir/a.out; \
		echo ""; \
	done

create:
	@if [ -z "$(ex)" ]; then \
		echo "$(RED)Error: Use 'make create ex=XX' (e.g., make create ex=00)$(RESET)"; \
		exit 1; \
	fi; \
	FOLDER="ex$$(echo $(ex) | sed 's/^ex//')"; \
	mkdir -p $$FOLDER/src $$FOLDER/include; \
	echo "$$MAKEFILE_CONTENT" > $$FOLDER/Makefile; \
	echo "$$MAIN_CONTENT" > $$FOLDER/src/main.cpp; \
	echo "$(GREEN)Created $$FOLDER$(RESET)"

format:
	@find . -type f \( -name "*.cpp" -o -name "*.hpp" \) -exec clang-format -style=$(CHOSEN_STYLE) -i {} +
	@echo "$(GREEN)Code formatted using $(YELLOW)$(if $(style),$(style),default)$(GREEN) style successfully.$(RESET)"

# --- Repo Management Logic ---

CURRENT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")

git:
	@if [ "$(IS_GIT)" = "no" ]; then \
		git init -q; \
		echo "$(CYAN)Git initialized.$(RESET)"; \
	else \
		echo "$(YELLOW)Git already initialized.$(RESET)"; \
	fi
	@if [ ! -f .gitignore ]; then \
		echo "$$GITIGNORE_CONTENT" > .gitignore; \
		echo "$(CYAN).gitignore created.$(RESET)"; \
	else \
		echo "$(YELLOW).gitignore already exists.$(RESET)"; \
	fi
	@$(MAKE) setup_remotes --no-print-directory -s

setup_remotes:
	@if [ -d .git ]; then \
		git remote remove github 2>/dev/null || true; \
		git remote add github $(GIT_URL) 2>/dev/null || true; \
		git remote remove 42 2>/dev/null || true; \
		git remote add 42 $(INTRA_URL) 2>/dev/null || true; \
		git remote remove both 2>/dev/null || true; \
		git remote add both $(GIT_URL) 2>/dev/null || true; \
		git remote set-url --add --push both $(INTRA_URL) 2>/dev/null || true; \
	fi

github:
	@if [ "$(IS_GIT)" = "no" ]; then \
		echo "$(RED)Error: Git not initialized. Run 'make git' first.$(RESET)"; \
	elif [ "$(GIT_URL)" = "git@github.com:your_username/your_repo.git" ]; then \
		echo "$(YELLOW)Suggestion: Update GIT_URL in Makefile to your repo link.$(RESET)"; \
	else \
		echo "$(BLUE)Verifying GitHub link...$(RESET)"; \
		if git ls-remote $(GIT_URL) > /dev/null 2>&1; then \
			$(MAKE) setup_remotes --no-print-directory -s; \
			echo "$(PURPLE)Broadcasting $(CURRENT_BRANCH) to github:main...$(RESET)"; \
			git push github $(CURRENT_BRANCH):main; \
			echo "$(GREEN)Broadcast successful!$(RESET)"; \
		else \
			echo "$(RED)Error: Could not reach GitHub. Check link or SSH keys.$(RESET)"; \
		fi \
	fi

42:
	@if [ "$(IS_GIT)" = "no" ]; then \
		echo "$(RED)Error: Git not initialized. Run 'make git' first.$(RESET)"; \
	elif [ "$(INTRA_URL)" = "git@vogsphere.42bangkok.com:vogsphere/intra-uuid-here.git" ] || [ -z "$(INTRA_URL)" ]; then \
		echo "$(YELLOW)Notice: INTRA_URL is still a placeholder. Skipping 42 push.$(RESET)"; \
	else \
		echo "$(BLUE)Preparing clean 42 submission (excluding Master Makefile)...$(RESET)"; \
		if git ls-remote $(INTRA_URL) > /dev/null 2>&1; then \
			$(MAKE) setup_remotes --no-print-directory -s; \
			# 1. Create a temporary branch from your current one \
			git checkout -b temp_42_submission --quiet; \
			# 2. Remove the Master Makefile from THIS branch only \
			git rm Makefile --quiet; \
			git commit -m "Clean submission" --quiet; \
			# 3. Push this clean branch to 42's master \
			echo "$(PURPLE)Broadcasting clean code to 42:master...$(RESET)"; \
			git push 42 temp_42_submission:master --force; \
			# 4. Switch back and clean up the temp branch \
			git checkout - --quiet; \
			git branch -D temp_42_submission --quiet; \
			echo "$(GREEN)Broadcast to 42 successful!$(RESET)"; \
		else \
			echo "$(RED)Error: Could not reach Intra. Check VPN/Network.$(RESET)"; \
		fi \
	fi

both:
	@$(MAKE) github --no-print-directory
	@$(MAKE) 42 --no-print-directory

status:
	@if [ -d .git ]; then \
		git remote -v; \
	else \
		echo "$(RED)Git not initialized.$(RESET)"; \
	fi

# Master Rules
.PHONY: all clean fclean re help

# Additional Rules
.PHONY: test create format

# Repo Rules
.PHONY: git setup_remotes github 42 both status