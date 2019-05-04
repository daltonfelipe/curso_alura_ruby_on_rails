class ProdutosController < ApplicationController

  def index
    @produtos = Produto.order :nome
    @produto_com_desconto = Produto.order(:preco).limit 1
  end

  # cria a variavel para receber os valores do formulario
  def new
    @departamentos = Departamento.all
    @produto = Produto.new
  end

  def create
    # pega os valores do 
    valores = params.require(:produto).permit(:nome, :descricao, :preco, :quantidade, :departamento_id)
    @produto = Produto.new valores

    if @produto.save
      flash[:notice] = "Produto salvo com sucesso!"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    id = params[:id]
    @produto = Produto.find(id)
    @departamentos = Departamento.all
    render :new
  end

  def update
    id = params[:id]
    @produto = Produto.find(id)
    valores = params.require(:produto).permit(:nome, :descricao, :preco, :quantidade, :departamento_id)
    if @produto.update valores
      flash[:notice] = "Produto atualizado com sucesso!"
      redirect_to root_url
    else
      @departamentos = Departamento.all
      render :new
    end
    
  end

  def destroy
    id = params[:id]
    Produto.destroy id
    redirect_to root_url
  end

  def busca
    @nome = params[:nome]
    # tecnica para prevencao de sql injection "nome like ?"
    # busca inteligente "% termo %"
    @produtos = Produto.where "nome like ?", "%#{@nome}%"
  end

end
