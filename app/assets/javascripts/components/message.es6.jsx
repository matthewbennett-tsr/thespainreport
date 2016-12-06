class Message extends React.Component {
    constructor(props) {
    super(props);
    this.state = {
      filterText: ''
    };
    
    this.handleUserInput = this.handleUserInput.bind(this);
  }

  handleUserInput(filterText, inStockOnly) {
    this.setState({
      filterText: filterText
    });
  }
  
  render () {
    return (
      <div>
        <SearchBar filterText={this.state.filterText} onUserInput={this.handleUserInput} />
        <div>{this.state.filterText}</div>
      </div>
    );
  }
}

Message.propTypes = {
  filterText: React.PropTypes.string
};

class SearchBar extends React.Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }
  
  handleChange() {
    this.props.onUserInput(
      this.filterTextInput.value,
      this.inStockOnlyInput.checked
    );
  }
  
  render() {
    return (
      <form>
        <input 
          type="text"
          placeholder="Search..."
          value={this.props.filterText}
          ref={(input) => this.filterTextInput = input}
          onChange={this.handleChange} />
      </form>
    );
  }
}