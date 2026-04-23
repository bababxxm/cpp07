# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: sklaokli <sklaokli@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/04/21 17:50:43 by sklaokli          #+#    #+#              #
#    Updated: 2026/04/23 13:47:30 by sklaokli         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# --- Master Configuration ---

EX_DIRS := $(sort $(wildcard ex??))
IS_GIT  := $(shell [ -d .git ] && echo "yes" || echo "no")

# --- Remote URLs ---

GIT_URL   := git@github.com:bababxxm/cpp07.git
INTRA_URL := 

# --- Style Configurations ---

define CLANG_FORMAT_CONTENT
BasedOnStyle: Google
UseTab: ForIndentation
IndentWidth: 4
TabWidth: 4
ColumnLimit: 80
PointerAlignment: Left
DerivePointerAlignment: false
BreakBeforeBraces: Attach
AccessModifierOffset: -4
SortIncludes: true
IncludeBlocks: Merge
AllowShortFunctionsOnASingleLine: Inline
AllowShortBlocksOnASingleLine: Always
BreakConstructorInitializers: BeforeComma
Standard: C++03
SpacesInAngles: false
endef
export CLANG_FORMAT_CONTENT

# Style selection logic
ifeq ($(style), google)
    CHOSEN_STYLE := "Google"
else ifeq ($(style), llvm)
    CHOSEN_STYLE := "LLVM"
else
    CHOSEN_STYLE := "file"
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
test
bin/
endef

define MAKEFILE_CONTENT
NAME        :=  test

SRC_DIR     :=  src
OBJ_DIR     :=  bin
INC_DIR     :=  include

FILES       :=  main.cpp

SRC         :=  $$(addprefix $$(SRC_DIR)/, $$(FILES))
OBJ         :=  $$(addprefix $$(OBJ_DIR)/, $$(FILES:%.cpp=%.o))
DEP         :=  $$(OBJ:.o=.d)

CXX         :=  c++
WFLAGS      :=  -Wall -Wextra -Werror
STDFLAGS    :=  -std=c++98 -pedantic
DEPFLAGS    :=  -MMD -MP
INCLUDE     :=  -I$$(INC_DIR)

CXXFLAGS    :=  $$(WFLAGS) $$(STDFLAGS) $$(DEPFLAGS) $$(INCLUDE)

all: $$(NAME)

$$(NAME): $$(OBJ)
	$$(CXX) $$(CXXFLAGS) $$(OBJ) -o $$(NAME)

$$(OBJ_DIR):
	mkdir -p $$(OBJ_DIR)

$$(OBJ_DIR)/%.o: $$(SRC_DIR)/%.cpp | $$(OBJ_DIR)
	$$(CXX) $$(CXXFLAGS) -c $$< -o $$@

clean:
	rm -rf $$(OBJ_DIR)

fclean: clean
	rm -f $$(NAME)

re: fclean all

-include $$(DEP)

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

# .DEFAULT_GOAL := help

all:
	@if [ -z "$(EX_DIRS)" ]; then \
		echo "$(YELLOW)No exercises found. Use 'make create ex=00'$(RESET)"; \
	else \
		echo "$(BLUE)Compiling $$(echo $(EX_DIRS) | sed 's/ /, /g')...$(RESET)"; \
		for dir in $(EX_DIRS); do \
			$(MAKE) -C $$dir --no-print-directory -s; \
		done; \
		echo "$(GREEN)All exercises finished successfully!$(RESET)"; \
	fi

help:
	@echo ""
	@echo "$(CYAN)Available commands for Master Makefile:$(RESET)"
	@echo ""
	@echo "$(BLUE)Build & Test:$(RESET)"
	@echo "  $(GREEN)make all$(RESET)            - Compile all exercises"
	@echo "  $(GREEN)make test$(RESET)           - Compile and run tests for all exercises"
	@echo "  $(GREEN)make leaks$(RESET)          - Run valgrind on all exercises"
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

clean:
	@for dir in $(EX_DIRS); do $(MAKE) clean -C $$dir --no-print-directory -s; done

fclean:
	@for dir in $(EX_DIRS); do $(MAKE) fclean -C $$dir --no-print-directory -s; done
	@rm -f .clang-format

re: fclean all

create:
	@if [ -z "$(ex)" ]; then \
		echo "$(YELLOW)Notice: Use 'make create ex=XX' (e.g., make create ex=00)$(RESET)"; \
	else \
		FOLDER="ex$$(echo $(ex) | sed 's/^ex//')"; \
		mkdir -p $$FOLDER/src $$FOLDER/include; \
		echo "$$MAKEFILE_CONTENT" > $$FOLDER/Makefile; \
		echo "$$MAIN_CONTENT" > $$FOLDER/src/main.cpp; \
		echo "$(GREEN)Exercise $(YELLOW)$$FOLDER$(GREEN) created successfully.$(RESET)"; \
	fi

.clang-format:
	@echo "$$CLANG_FORMAT_CONTENT" > .clang-format

format: .clang-format
	@if command -v clang-format >/dev/null 2>&1; then \
		find . -type f \( -name "*.cpp" -o -name "*.hpp" -o -name "*.tpp" \) -exec clang-format -style=$(CHOSEN_STYLE) -i {} +; \
		echo "$(GREEN)Code formatted using $(YELLOW)$(if $(style),$(style),default)$(GREEN) style successfully.$(RESET)"; \
	else \
		echo "$(YELLOW)Notice: clang-format is not installed.$(RESET)"; \
	fi

test:
	@for dir in $(EX_DIRS); do \
		$(MAKE) -C $$dir --no-print-directory -s; \
		echo "$(YELLOW)Running $$dir tests...$(RESET)"; \
		./$$dir/test; \
		echo ""; \
	done

leaks:
	@for dir in $(EX_DIRS); do \
		$(MAKE) -C $$dir --no-print-directory -s; \
		echo "$(YELLOW)Checking leaks in $$dir...$(RESET)"; \
		valgrind --leak-check=full ./$$dir/test; \
		echo ""; \
	done

# --- Repo Management Logic ---

FORCE_FLAG=""
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
			F_FLAG=""; \
			if [ "$(force)" = "yes" ]; then F_FLAG="--force"; fi; \
			echo "$(PURPLE)Broadcasting $(CURRENT_BRANCH) to github:main$${F_FLAG:+ (FORCED)}...$(RESET)"; \
			git push github $(CURRENT_BRANCH):main $$F_FLAG; \
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
		echo "$(BLUE)Verifying 42 Intra link...$(RESET)"; \
		if git ls-remote $(INTRA_URL) > /dev/null 2>&1; then \
			$(MAKE) setup_remotes --no-print-directory -s; \
			F_FLAG=""; \
			if [ "$(force)" = "yes" ]; then F_FLAG="--force"; fi; \
			echo "$(PURPLE)Broadcasting $(CURRENT_BRANCH) to 42:main$${F_FLAG:+ (FORCED)}...$(RESET)"; \
			git push 42 $(CURRENT_BRANCH):main $$F_FLAG; \
			echo "$(GREEN)Broadcast successful!$(RESET)"; \
		else \
			echo "$(RED)Error: Could not reach Intra. Check VPN/Network.$(RESET)"; \
		fi \
	fi

both:
	@$(MAKE) github force=$(force) --no-print-directory
	@$(MAKE) 42 force=$(force) --no-print-directory

status:
	@echo "$(BLUE)Current Branch:$(RESET) $(PURPLE)$(CURRENT_BRANCH)$(RESET)"
	@echo ""
	@printf "$(BLUE)%-12s %-10s$(RESET)\n" "REMOTE" "STATUS"
	
	@printf "%-12s " "GitHub"
	@if [ "$(GIT_URL)" = "git@github.com:your_username/your_repo.git" ] || [ -z "$(GIT_URL)" ]; then \
		echo "$(RED)[OFFLINE]$(RESET)"; \
	elif git ls-remote --exit-code github main > /dev/null 2>&1; then \
		echo "$(GREEN)[ONLINE]$(RESET)"; \
	else \
		echo "$(RED)[OFFLINE]$(RESET)"; \
	fi
	
	@printf "%-12s " "42 Intra"
	@if [ "$(INTRA_URL)" = "git@vogsphere.42bangkok.com:vogsphere/intra-uuid-here.git" ] || [ -z "$(INTRA_URL)" ]; then \
		echo "$(RED)[OFFLINE]$(RESET)"; \
	elif git ls-remote --exit-code 42 master > /dev/null 2>&1; then \
		echo "$(GREEN)[ONLINE]$(RESET)"; \
	else \
		echo "$(RED)[OFFLINE]$(RESET)"; \
	fi
	
	@echo ""
	@echo "$(YELLOW)GH:$(RESET) $(if $(filter-out git@github.com:your_username/your_repo.git,$(GIT_URL)),$(GIT_URL),$(RED)Not Configured$(RESET))"
	@echo "$(YELLOW)42:$(RESET) $(if $(filter-out git@vogsphere.42bangkok.com:vogsphere/intra-uuid-here.git,$(INTRA_URL)),$(INTRA_URL),$(RED)Not Configured$(RESET))"

# Master Rules
.PHONY: all clean fclean re help

# Additional Rules
.PHONY: create format test leaks

# Repo Rules
.PHONY: git setup_remotes github 42 both status