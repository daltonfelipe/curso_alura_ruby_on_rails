class ProdutosController < ApplicationController

  # antes de executar [:edit, :update, :destroy] pega o produto no banco
  before_action :set_produto, only: [:edit, :update, :destroy]

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
    # pega os valores do post
    @produto = Produto.new produto_params

    if @produto.save
      flash[:notice] = "Produto salvo com sucesso!"
      redirect_to root_url
    else
      renderiza :new
    end
  end

  def edit
    renderiza :edit
  end

  def update
    if @produto.update produto_params
      flash[:notice] = "Produto atualizado com sucesso!"
      redirect_to root_url
    else
      renderiza :edit  
    end
    
  end

  def destroy
    @produto.destroy
    redirect_to root_url
  end

  def busca
    @nome = params[:nome]
    # tecnica para prevencao de sql injection "nome like ?"
    # busca inteligente "% termo %"
    @produtos = Produto.where "nome like ?", "%#{@nome}%"
  end


  private

  def produto_params
    params.require(:produto).permit(:nome, :descricao, :preco, :quantidade, :departamento_id)
  end

  def set_produto
    @produto = Produto.find params[:id]
  end

  def renderiza view
    @departamentos = Departamento.all
    render view
  end


end
