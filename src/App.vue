<template>
  <div class="wrapper">
    <ChangelogHeader
      v-model:loader="loaderList"
      @doSearch="doSearch"
    />

    <main class="main">
      <div class="container">
        <div class="main__inner">
          <div class="main__col">
            <ChangelogFilters
              :filters="filters"
              :loader="loaderFilters"
              @dateFilter="filterDateRange"
              @activeFilters="filterCheckboxGroup"
            />
          </div>

          <div class="main__col">
            <ChangelogList
              :currentPage="page"
              :list="changelogList"
              :loader="loaderList"
              :filtersList="filtersList"
              :pages="pages"
              @updateList="getChangelogList"
              @changePage="changePage"
              @addNewTags="addNewTags"
            />
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script>
  import axios from "axios";
  import ChangelogHeader from "@/components/ChangelogHeader";
  import ChangelogList from "@/components/ChangelogList";
  import ChangelogFilters from "@/components/ChangelogFilters";

  export default {
    name: "App",
    components: {
      ChangelogHeader,
      ChangelogFilters,
      ChangelogList,
    },
    data: () => {
      return {
        changelogList: [],
        filters: {
          type: {
            filterName: "Type",
            filterValues: [],
          },
          tags: {
            filterName: "Tags",
            filterValues: [],
          }
        },
        filtersList: {
          tags: [],
          type: []
        },
        loaderList: false,
        loaderFilters: false,
        paging: {},
        pages: 1,
        page: 1,
        configList: {
          paging: {
            page: 0,
            itemsOnPage: 10
          },
          sort: [
            {
              field: "TIMESTAMP",
              order: "DESC"
            }
          ]
        },
      };
    },

    methods: {
      updateAppData() {
        this.getChangelogList();
        this.getFilters();
      },

      addNewTags(newTagsList) {
        console.log(newTagsList)
        this.filtersList.tags.push(...newTagsList.tagsList);
        this.filters.tags.filterValues.push(...newTagsList.filtersTags);
      },

      getChangelogList() {
        this.loaderList = true;
        this.loaderFilters = true;
        axios
          .post("api/changelog/list/", this.configList)
          .then((response) => {
            let data = response.data.results.data;
            this.changelogList = data.items;
            this.pages = Math.ceil(data.paging.items / data.paging.itemsOnPage);
            this.loaderList = false;
            this.loaderFilters = false;
          })
          .catch((error) => console.log(error));
      },

      getFilters() {
        axios
          .get("api/changelog/types/")
          .then((response) => {
            this.filtersList.type = response.data.results.data;

            this.filters.type.filterName = 'Type'
            this.filters.type.filterValues = response.data.results.data.map(item => {
              return {filterValueName: item, isActiveFilter: false};
            });

          })
          .catch((error) => console.log(error));

        axios
          .get("api/changelog/tags/")
          .then((response) => {
            this.filtersList.tags = response.data.results.data;

            this.filters.tags.filterName = 'Tags'
            this.filters.tags.filterValues = response.data.results.data.map(item => {
              return {filterValueName: item, isActiveFilter: false};
            });

          })
          .catch((error) => console.log(error));
      },

      changePage(page) {
        this.page = page;
        this.configList.paging.page = page - 1;
        this.getChangelogList();
      },

      filterDateRange(dateRange) {
        if (dateRange.length) {
          this.configList.timeRange = {
            start: dateRange[0],
            end: dateRange[1]
          };
        } else {
          delete this.configList.timeRange;
        }
        this.configList.paging.page = 0;
        this.changePage(1);
      },

      filterCheckboxGroup(filters) {
        this.configList.groupFilters = [
          {
            field: "TAG",
            value: filters.tags
          },
          {
            field: "TYPE",
            value: filters.type
          }
        ];

        this.configList.paging.page = 0;
        this.changePage(1);
      },

      doSearch(value) {
        this.configList.searchTerm = value;
        this.configList.paging.page = 0;
        this.changePage(1);
      }
    },

    mounted() {
      this.updateAppData()
    },

    computed: {}
  };
</script>

<style lang="scss">
  .dp__main {
    position: relative;
  }
</style>
